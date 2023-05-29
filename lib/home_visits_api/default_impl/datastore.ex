defmodule HomeVisitsApi.DefaultImpl.DataStore do
  @moduledoc false

  @fee 0.15

  alias HomeVisitsApi.User
  alias HomeVisitsApi.Fulfill
  alias HomeVisitsApi.Visit
  alias HomeVisitsApi.Repo
  alias Ecto.Changeset
  import Ecto.Query

  def create_user(user) when is_map(user) do
    Repo.all(from(u in Schema.User, where: u.email == ^user.email))
    |> case do
      [_found_user] ->
        {:error, :email_already_registered}

      [] ->
        # to be replaced by faucet
        usr_default_mins = user |> Map.put(:minutes, 60.0)

        %Schema.User{}
        |> Changeset.cast(usr_default_mins, [:first_name, :last_name, :email, :minutes, :roles])
        |> Repo.insert()
        |> handle_user_results
    end
  end

  def request_visit(req) when is_map(req) do
    Repo.get_by(Schema.User, email: req.email)
    |> validate_visit_request(req)
    |> case do
      {:ok, user} ->
        %Schema.Visit{
          member: user,
          member_id: user.uuid,
          date: req.date,
          minutes: req.minutes,
          tasks: req.tasks
        }
        |> Repo.insert()
        |> handle_visit_request_results

      {:error, error} ->
        {:error, error}
    end
  end

  def fetch_visits() do
    Repo.all(Schema.Visit)
    |> case do
      [] ->
        {:ok, []}

      visits ->
        {:ok,
         Enum.map(visits, fn visit ->
           %Visit{id: visit.uuid, tasks: visit.tasks, minutes: visit.minutes, date: visit.date}
         end)}
    end
  end

  def fulfill_visit(%Fulfill{email: email, id: fulfillment_id} = fulfillment)
      when is_map(fulfillment) do
    Repo.one(from(u in Schema.User, where: u.email == ^email))
    |> validate_visit_fulfillment
    |> case do
      {:ok, pal} ->
        [visit] =
          Repo.all(
            from(v in Schema.Visit,
              where: v.uuid == ^fulfillment_id,
              select: v,
              preload: :pal,
              preload: :member
            )
          )

        visit_fee = visit.minutes * @fee
        visit_amount = visit.minutes + visit_fee

        pal_changeset =
          pal
          |> Ecto.Changeset.change()
          |> Ecto.Changeset.put_change(:minutes, pal.minutes + visit_amount)

        visit_update =
          visit
          |> Changeset.change()
          |> Changeset.put_assoc(:pal, pal_changeset)
          |> Changeset.put_change(:pal_id, pal.uuid)
          |> Changeset.put_assoc(:member, %{
            uuid: visit.member.uuid,
            minutes: visit.member.minutes - visit_amount
          })
          |> Repo.update!()

        %Schema.Transaction{
          visit_id: visit_update.uuid,
          visit: visit_update,
          member_id: visit_update.member.uuid,
          member: visit_update.member,
          pal_id: visit_update.pal.uuid,
          pal: visit_update.pal,
          fee: visit_fee
        }
        |> Repo.insert()

        {:ok, :fulfilled}

      {:error, error} ->
        {:error, error}
    end
  end

  defp validate_visit_fulfillment(%Schema.User{roles: roles} = user) do
    if "pal" in roles do
      {:ok, user}
    else
      {:error, :not_authorized}
    end
  end

  defp validate_visit_fulfillment(_) do
    {:error, :failed_to_fulfill}
  end

  defp validate_visit_request(%Schema.User{minutes: minutes, roles: roles} = user, req)
       when minutes >= req.minutes + req.minutes * @fee do
    if "member" in roles do
      {:ok, user}
    else
      {:error, :not_authorized}
    end
  end

  defp validate_visit_request(%Schema.User{minutes: minutes} = _user, req)
       when minutes < req.minutes + req.minutes * @fee do
    {:error, :insufficient_minutes}
  end

  defp validate_visit_request(nil, _req) do
    {:error, :unknown_account}
  end

  defp validate_visit_request(_, _req) do
    {:error, :failed_to_request_visit}
  end

  defp handle_visit_request_results({:ok, _visit}), do: {:ok, :request_pending}

  defp handle_visit_request_results({:error, _}) do
    {:error, :failed_to_request_visit}
  end

  defp handle_visit_request_results(_) do
    {:error, :failed_to_request_visit}
  end

  defp handle_user_results({:ok, user}) do
    {:ok,
     %User{
       first_name: user.first_name,
       last_name: user.last_name,
       email: user.email,
       roles: user.roles
     }}
  end

  defp handle_user_results({:error, _}) do
    {:error, :failed_to_create_user}
  end
end

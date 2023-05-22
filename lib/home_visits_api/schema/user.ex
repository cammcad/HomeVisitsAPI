defmodule Schema.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:minutes, :float)
    field(:roles, {:array, :string}, default: [])

    timestamps()
  end
end

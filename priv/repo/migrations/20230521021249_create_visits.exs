defmodule HomeVisitsApi.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits, primary_key: false) do
      add :uuid,       :uuid, primary_key: true
      add :member_id,  references(:users, type: :uuid, column: :uuid)
      add :pal_id,     references(:users, type: :uuid, column: :uuid)
      add :date,       :date
      add :minutes,    :real
      add :tasks,      {:array, :string}, default: []

      timestamps()
    end
  end
end

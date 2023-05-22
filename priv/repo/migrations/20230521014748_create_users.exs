defmodule HomeVisitsApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :uuid,         :uuid, primary_key: true
      add :first_name, :string
      add :last_name,  :string
      add :email,      :string
      add :minutes,    :real
      add :roles,      {:array, :string}, default: []

      timestamps()
    end
  end
end

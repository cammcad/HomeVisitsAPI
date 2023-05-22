defmodule HomeVisitsApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :uuid,         :uuid, primary_key: true
      add :member_id,  references(:users, type: :uuid, column: :uuid)
      add :pal_id,     references(:users, type: :uuid, column: :uuid)
      add :visit_id,   references(:visits, type: :uuid, column: :uuid)
      add :fee,        :real

      timestamps()
    end
  end
end

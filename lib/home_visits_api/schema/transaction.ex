defmodule Schema.Transaction do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "transactions" do
    field(:fee, :float)

    belongs_to(:member, Schema.User, foreign_key: :member_id, references: :uuid, type: :binary_id)
    belongs_to(:pal, Schema.User, foreign_key: :pal_id, references: :uuid, type: :binary_id)
    belongs_to(:visit, Schema.Visit, foreign_key: :visit_id, references: :uuid, type: :binary_id)

    timestamps()
  end
end

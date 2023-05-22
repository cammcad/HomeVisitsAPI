defmodule Schema.Visit do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "visits" do
    field(:date, :date)
    field(:minutes, :float)
    field(:tasks, {:array, :string}, default: [])

    belongs_to(:member, Schema.User, foreign_key: :member_id, references: :uuid, type: :binary_id)
    belongs_to(:pal, Schema.User, foreign_key: :pal_id, references: :uuid, type: :binary_id)

    timestamps()
  end
end

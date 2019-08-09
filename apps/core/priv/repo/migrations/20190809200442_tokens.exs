defmodule FinancialSystem.Core.Repo.Migrations.Tokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:token, :string)

      add(:user_id, references(:users, type: :uuid), null: false)

      timestamps()
    end

    create(unique_index(:tokens, [:token]))
  end
end

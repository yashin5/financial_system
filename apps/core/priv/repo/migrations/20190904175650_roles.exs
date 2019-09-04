defmodule FinancialSystem.Core.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:role, :string)

      add(:user_id, references(:users, type: :uuid), null: false)

      timestamps()
    end

    create(unique_index(:tokens, [:role]))
  end
end

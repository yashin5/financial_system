defmodule FinancialSystem.Core.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:role, :string)

      timestamps()
    end

    create(unique_index(:roles, [:role]))
  end
end

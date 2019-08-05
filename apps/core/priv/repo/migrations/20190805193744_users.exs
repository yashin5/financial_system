defmodule FinancialSystem.Core.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:email, :string)
      add(:password_hash, :string, null: true)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end

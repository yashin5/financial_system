defmodule FinancialSystem.Repo.Migrations.Accounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:active, :boolean)
      add(:account_id, :uuid)
      add(:currency, :string)
      add(:value, :integer)

      add(:user_id, references(:users, type: :uuid), null: false)

      timestamps()
    end
  end
end

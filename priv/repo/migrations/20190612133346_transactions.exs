defmodule FinancialSystem.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:account_id, references(:accounts, type: :uuid))
      add(:operation, :string)
      add(:value, :integer)

      timestamps()
    end
  end
end

defmodule FinancialSystem.Repo.Migrations.Accounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:currency, :string)
      add(:value, :integer)
    end
  end
end

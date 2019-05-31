defmodule FinancialSystem.Repo.Migrations.Accounts do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add(:id, :string)
      add(:name, :string)
      add(:currency, :string)
      add(:value, :integer)
    end
  end
end

defmodule FinancialSystem.Core.Repo.Migrations.Contacts do
  use Ecto.Migration

  def change do
    create table(:contacts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:nickname, :string)
      add(:account_id, :uuid)
      add(:email, :string)

      add(:user_id, references(:users, type: :uuid), null: false)

      timestamps()
    end
  end
end

defmodule FinancialSystem.Core.Repo.Migrations.Permissions do
  use Ecto.Migration

  def change do
    create table(:permissions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:can_view, :boolean)
      add(:can_create, :boolean)
      add(:can_delete, :boolean)
      add(:can_view_all, :boolean)

      add(:roles_id, references(:roles, type: :uuid), null: false)

      timestamps()
    end
  end
end

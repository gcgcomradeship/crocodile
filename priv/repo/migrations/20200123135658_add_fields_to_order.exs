defmodule Crocodile.Repo.Migrations.AddFieldsToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:name, :string)
      add(:email, :string)
      add(:post_index, :string)
      add(:delivery_type, :integer)
    end
  end
end

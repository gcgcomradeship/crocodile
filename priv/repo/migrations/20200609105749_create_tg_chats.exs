defmodule Crocodile.Repo.Migrations.CreateTgChats do
  use Ecto.Migration

  def change do
    create table(:tg_chats) do
      add(:first_name, :string)
      add(:chat_id, :integer)
      add(:last_name, :string)
      add(:username, :string)
      add(:approve, :boolean, default: false)
      timestamps()
    end
  end
end

defmodule Crocodile.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add(:author, :string)
      add(:title, :string)
      add(:description, :text)
      add(:inner_html, :text)

      timestamps()
    end
  end
end

defmodule Crocodile.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    timestamps()

    belongs_to(:session, Crocodile.Session, type: :binary_id)
    belongs_to(:blog, Crocodile.Blog)
  end

  @required_fields ~w(session_id blog_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

defmodule Crocodile.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "sessions" do
    timestamps()

    belongs_to(:user, Crocodile.User)
  end

  @required_fields ~w()a
  @optional_fields ~w(user_id)a

  def changeset(session, attrs) do
    session
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

defmodule Crocodile.TgChat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tg_chats" do
    field(:first_name, :string)
    field(:chat_id, :integer)
    field(:last_name, :string)
    field(:username, :string)
    field(:approve, :boolean)
    timestamps()
  end

  @required_fields ~w(chat_id)a
  @optional_fields ~w(first_name last_name username approve)a

  @doc false
  def changeset(tg_chat, attrs) do
    tg_chat
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

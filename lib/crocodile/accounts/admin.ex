defmodule Crocodile.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crocodile.Accounts.Admin
  alias Comeonin.Bcrypt

  schema "admins" do
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :encrypted_password])
    |> unique_constraint(:email)
    |> validate_required([:email, :encrypted_password])
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end

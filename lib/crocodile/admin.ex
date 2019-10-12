defmodule Crocodile.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)

    timestamps()
  end

  @required_fields ~w(email)a
  @optional_fields ~w()a

  def changeset(admin, attrs) do
    admin
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> password_update(attrs)
  end

  defp password_update(changeset, %{password: password}), do: put_password(changeset, password)

  defp password_update(changeset, %{"password" => ""}), do: changeset

  defp password_update(changeset, %{"password" => password}),
    do: put_password(changeset, password)

  defp password_update(changeset, _attrs), do: changeset

  defp put_password(changeset, password),
    do: put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
end

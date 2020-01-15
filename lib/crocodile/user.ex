defmodule Crocodile.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field(:email, :string)
    field(:phone, :string)
    field(:mailing, :boolean)
    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()

    has_many(:sessions, Crocodile.Session, on_delete: :nilify_all)
  end

  @required_fields ~w(email)a
  @sign_up_required_fields ~w(email password password_confirmation)a
  @optional_fields ~w(phone mailing)a

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> password_update(attrs)
  end

  def sign_up_changeset(user, %{"user" => user_params}) do
    user
    |> cast(user_params, @sign_up_required_fields ++ @optional_fields)
    |> validate_required(@sign_up_required_fields, message: "<Не может быть пустым>")
    |> unique_constraint(:email, message: "<Аккаунт с таким email уже существует>")
    |> validate_length(:password, min: 6, message: "<Пароль должен содержать не менее 6 символов>")
    |> check_password_confirmation(user_params)
    |> password_update(user_params)
  end

  defp check_password_confirmation(changeset, params) do
    case params["password"] == params["password_confirmation"] && !is_nil(params["password"]) do
      true -> changeset
      _ -> add_error(changeset, :password_confirmation, "<Не совпадает с паролем>")
    end
  end

  defp password_update(changeset, %{password: password}), do: put_password(changeset, password)

  defp password_update(changeset, %{"password" => ""}), do: changeset

  defp password_update(changeset, %{"password" => password}),
    do: put_password(changeset, password)

  defp password_update(changeset, _attrs), do: changeset

  defp put_password(changeset, password),
    do: put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(password))
end

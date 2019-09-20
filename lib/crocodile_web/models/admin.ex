defmodule CrocodileWeb.Admin do
  use CrocodileWeb, :model

  schema "admins" do
    field :email, :string
    field :password, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end
end

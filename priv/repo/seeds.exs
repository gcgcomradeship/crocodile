# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Crocodile.Repo.insert!(%Crocodile.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Crocodile.Setting
alias Crocodile.Repo

settings = %{
  "delivery_prices" => %{
    "pick_up" => 300,
    "courier" => 400,
    "post" => 500
  }
}

for {name, data} <- settings do
  (Repo.get_by(Setting, name: name) || %Setting{})
  |> Setting.changeset(%{name: name, data: data})
  |> Repo.insert_or_update()
end

defmodule Crocodile.Services.Sync.DB do
  use CrocodileWeb, :services

  alias Crocodile.Item

  def insert_or_update(nil), do: nil

  def insert_or_update(%{partner_id: partner_id} = struct) do
    item = Item |> Repo.get_by(partner_id: partner_id)

    (item || %Item{})
    |> Item.changeset(struct)
    |> Repo.insert_or_update()
  end
end

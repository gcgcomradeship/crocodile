defmodule CrocodileWeb.LiveHandlers.AdminTag do
  use CrocodileWeb, :live_handlers

  alias Crocodile.Services.Opt
  alias CrocodileWeb.LiveHandlers.State

  # def call(socket, data, value) do
  #   socket
  # end

  def call(%{assigns: %{admin_id: admin_id, state: state}} = socket, "tag_" <> cmd, value) do
    new_state = exec(state, cmd, value, admin_id)
    State.Admin.set(new_state, admin_id)

    assign(socket, :state, new_state)
  end

  defp state_update(state, item_tags, admin_id) do
    new_state =
      state
      |> Map.put("tags", item_tags)

    State.Admin.item_data_set(new_state, admin_id)
    new_state
  end

  defp exec(state, "set_category", %{"category" => category}, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      category: category
    }

    item_tags = Opt.tags_add(params)
    state_update(state, item_tags, admin_id)
  end

  defp exec(state, "rm_category", _, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      field: "category"
    }

    item_tags = Opt.tags_rm(params)
    state_update(state, item_tags, admin_id)
  end

  defp exec(state, "set_subcategory", %{"subcategory" => subcategory}, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      subcategory: subcategory
    }

    item_tags = Opt.tags_add(params)
    state_update(state, item_tags, admin_id)
  end

  defp exec(state, "rm_subcategory", _, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      field: "subcategory"
    }

    item_tags = Opt.tags_rm(params)
    state_update(state, item_tags, admin_id)
  end

  defp exec(state, "add_tag", %{"tag" => tag}, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      add_tag: tag
    }

    item_tags = Opt.tags_add(params)
    state_update(state, item_tags, admin_id)
  end

  defp exec(state, "rm_tag", %{"tag" => tag}, admin_id) do
    params = %{
      item_id: state["item"]["id"],
      rm_tag: tag
    }

    item_tags = Opt.tags_add(params)
    state_update(state, item_tags, admin_id)
  end
end

defmodule CrocodileWeb.PageController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Items
  alias Crocodile.Page

  def index(conn, _params) do
    render(conn, "index.html",
      # croc_choice: Items.croc_choice(),
      # new: Items.new(),
      # recommend: Items.recommend(),
      # hit: Items.hit()
      croc_choice: [],
      new: [],
      recommend: [],
      hit: []
    )
  end

  def show(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, %{"name" => name}) do
    Page
    |> Repo.get_by(name: name)
    |> case do
      nil ->
        redirect(conn, to: Routes.page_path(conn, :index))

      page ->
        render(conn, "show.html", page: page, breadcrumbs: breadcrumbs(conn, name))
    end
  end

  def example(conn, _params) do
    render(conn, "example.html", hide_layout: true)
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, name) do
    breadcrumbs
    |> Kernel.++([{t(name), "#"}])
  end
end

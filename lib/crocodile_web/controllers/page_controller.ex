defmodule CrocodileWeb.PageController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Items

  def index(conn, _params) do
    render(conn, "index.html",
      croc_choice: Items.croc_choice(),
      new: Items.new(),
      recommend: Items.recommend(),
      hit: Items.hit()
    )
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def delivery(conn, _params) do
    render(conn, "delivery.html")
  end

  def main(conn, _params) do
    render(conn, "main.html")
  end

  def example(conn, _params) do
    render(conn, "example.html", hide_layout: true)
  end
end

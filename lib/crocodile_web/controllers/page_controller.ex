defmodule CrocodileWeb.PageController do
  use CrocodileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def catalog(conn, _params) do
    render(conn, "catalog.html")
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

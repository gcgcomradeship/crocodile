defmodule CrocodileWeb.BlogController do
  use CrocodileWeb, :controller

  alias Crocodile.Blog
  alias Crocodile.Context.Blogs

  def index(%{assigns: %{session: %{id: sid}}} = conn, params) do
    blogs = Blogs.all(sid)

    render(conn, "index.html", blogs: blogs, breadcrumbs: breadcrumbs(conn, params))
  end

  def show(%{assigns: %{session: %{id: sid}}} = conn, %{"id" => id} = params) do
    blog = Blogs.get(id, sid)
    render(conn, "show.html", blog: blog, breadcrumbs: breadcrumbs(conn, params))
  end

  def like(%{assigns: %{session: %{id: sid}}} = conn, %{"blog_id" => blog_id} = _params) do
    case Blogs.like(sid, blog_id) do
      nil ->
        conn
        |> render("error.json")

      count ->
        render(conn, "success.json", count: count)
    end
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, %{"id" => id} = params) do
    blog = Blog |> Repo.get(params["id"] || 0)

    breadcrumbs
    |> Kernel.++([{"Блог", Routes.blog_path(conn, :index)}])
    |> Kernel.++([{blog.title, "#"}])
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, _params) do
    breadcrumbs ++ [{"Блог", Routes.blog_path(conn, :index)}]
  end
end

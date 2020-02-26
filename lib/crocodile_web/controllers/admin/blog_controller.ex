defmodule CrocodileWeb.Admin.BlogController do
  use CrocodileWeb, :controller

  alias Crocodile.Blog

  def index(conn, _params) do
    blogs =
      Blog
      |> Repo.all()

    render(conn, "index.html", blogs: blogs)
  end

  def new(conn, _params) do
    changeset = Blog.changeset(%Blog{}, %{})
    render(conn, "new.html", blog: changeset.data, changeset: changeset)
  end

  def create(%{assigns: %{current_admin: current_admin}} = conn, %{"blog" => blog_params}) do
    changeset = Blog.changeset(%Blog{}, blog_params)

    case Repo.insert(changeset) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_blog_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          blog: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    blog = Blog |> Repo.get(id)
    changeset = Blog.changeset(blog, %{password: ""})
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  def update(%{assigns: %{current_admin: current_admin}} = conn, %{
        "id" => id,
        "blog" => blog_params
      }) do
    blog = Blog |> Repo.get(id)

    changeset = Blog.changeset(blog, blog_params)

    case Repo.update(changeset) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_blog_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          blog: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def delete(%{assigns: %{current_admin: current_admin}} = conn, %{"id" => id}) do
    blog = Blog |> Repo.get(id)
    {:ok, _blog} = Repo.delete(blog)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_blog_path(conn, :index))
  end
end

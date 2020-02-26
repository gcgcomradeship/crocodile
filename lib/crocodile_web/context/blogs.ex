defmodule Crocodile.Context.Blogs do
  use CrocodileWeb, :context

  alias Crocodile.Blog
  alias Crocodile.Like

  def all(sid) do
    Blog
    |> join(:left, [b], l in Like, on: l.blog_id == b.id)
    |> join(:left, [b, l], sl in Like, on: sl.blog_id == b.id and sl.session_id == ^sid)
    |> group_by([b, l, sl], b.id)
    |> select(
      [b, l, sl],
      %{
        id: b.id,
        image: b.image,
        author: b.author,
        title: b.title,
        description: b.description,
        inner_html: b.inner_html,
        inserted_at: b.inserted_at,
        like_count: count(l.id),
        liked: count(l.id) != 0
      }
    )
    |> order_by([b, l, sl], desc: b.inserted_at)
    |> Repo.all()
  end

  # def all() do
  #   Blog
  #   |> preload(:likes)
  #   |> order_by([b], desc: b.inserted_at)
  #   |> Repo.all()
  # end

  def get(id, sid) do
    Blog
    |> join(:left, [b], l in Like, on: l.blog_id == b.id)
    |> join(:left, [b, l], sl in Like, on: sl.blog_id == b.id and sl.session_id == ^sid)
    |> group_by([b, l, sl], b.id)
    |> select(
      [b, l, sl],
      %{
        id: b.id,
        image: b.image,
        author: b.author,
        title: b.title,
        description: b.description,
        inner_html: b.inner_html,
        inserted_at: b.inserted_at,
        like_count: count(l.id),
        liked: count(l.id) != 0
      }
    )
    |> Repo.get(id)
  end

  def like(sid, blog_id) do
    case can_like?(sid, blog_id) do
      true -> set_like(sid, blog_id)
      false -> del_like(sid, blog_id)
    end
  end

  defp can_like?(sid, blog_id) do
    Like
    |> where([l], l.blog_id == ^blog_id and l.session_id == ^sid)
    |> Repo.all()
    |> List.last()
    |> case do
      nil -> true
      _ -> false
    end
  end

  defp set_like(sid, blog_id) do
    %Like{}
    |> Like.changeset(%{blog_id: blog_id, session_id: sid})
    |> Repo.insert()
    |> case do
      {:ok, %Like{}} -> like_count(blog_id)
      _error -> nil
    end
  end

  defp del_like(sid, blog_id) do
    Like
    |> where([l], l.blog_id == ^blog_id and l.session_id == ^sid)
    |> Repo.all()
    |> List.last()
    |> Repo.delete()

    like_count(blog_id)
  end

  defp like_count(blog_id) do
    Like
    |> where([l], l.blog_id == ^blog_id)
    |> select([l], count(l.id))
    |> Repo.one()
  end
end

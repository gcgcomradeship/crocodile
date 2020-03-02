defmodule CrocodileWeb.ItemView do
  use CrocodileWeb, :view

  def item_details(product) do
    base_params = [
      vendor: "Бренд",
      collection: "Коллекция",
      pack: "Упаковка",
      size: "Размер",
      color: "Цвет"
    ]

    details(product, base_params)
  end

  def size_details(product) do
    base_params = [
      brutto: "Вес (кг)",
      length: "Длина (см)",
      diameter: "Диаметр (см)",
      batteries: "Батарейки",
      material: "Материал"
    ]

    details(product, base_params)
  end

  def pagination_links(conn, page) do
    content_tag :div, class: "product-pagination" do
      content_tag :div, class: "theme-paggination-block" do
        content_tag :div, class: "row" do
          concat(pages(page, conn), text(page))
        end
      end
    end
  end

  defp concat({:safe, raw1}, {:safe, raw2}), do: {:safe, raw1 ++ raw2}

  defp pages(page, conn) do
    raw_data = Scrivener.HTML.raw_pagination_links(page)

    content_tag :div, class: "col-xl-10 col-md-10 col-sm-12" do
      content_tag :nav, [{:aria, [label: "Page navigation"]}] do
        content_tag :ul, class: "pagination" do
          for row <- raw_data do
            li(row, conn)
          end
        end
      end
    end
  end

  defp text(%{page_number: page_number, page_size: page_size, total_entries: total_entries}) do
    from_page = (page_number - 1) * page_size + 1

    to_page = from_page + page_size - 1

    content_tag :div, class: "col-xl-2 col-md-2 col-sm-12" do
      content_tag :div, class: "product-search-count-bottom" do
        content_tag :h5 do
          "#{from_page} - #{to_page} из #{total_entries}"
        end
      end
    end
  end

  defp li({">>", page_num}, %{params: params} = conn) do
    link = Routes.item_path(conn, :index, Map.merge(params, %{"page" => page_num}))

    content_tag :li, class: "page-item" do
      content_tag :a, [{:class, "page-link"}, {:href, link}, {:aria, [label: "Next"]}] do
        {:safe, ico} =
          content_tag :span, [{:aria, [hidden: "true"]}] do
            content_tag(:i, "", class: "fa fa-chevron-right")
          end

        {:safe, spn} =
          content_tag :span, class: "sr-only" do
            "Next"
          end

        {:safe, ico ++ spn}
      end
    end
  end

  defp li({"<<", page_num}, %{params: params} = conn) do
    link = Routes.item_path(conn, :index, Map.merge(params, %{"page" => page_num}))

    content_tag :li, class: "page-item" do
      content_tag :a, [{:class, "page-link"}, {:href, link}, {:aria, [label: "Previous"]}] do
        {:safe, ico} =
          content_tag :span, [{:aria, [hidden: "true"]}] do
            content_tag(:i, "", class: "fa fa-chevron-left")
          end

        {:safe, spn} =
          content_tag :span, class: "sr-only" do
            "Previous"
          end

        {:safe, ico ++ spn}
      end
    end
  end

  defp li({:ellipsis, safe}, _conn) do
    content_tag :li, class: "page-item" do
      content_tag :a, class: "page-link", href: "#" do
        content_tag(:span, safe, class: "pagination-ellipsis")
      end
    end
  end

  defp li({_, page_num}, %{params: params} = conn) do
    active = if "#{page_num}" == params["page"], do: "active"
    link = Routes.item_path(conn, :index, Map.merge(params, %{"page" => page_num}))

    content_tag :li, class: "page-item #{active}" do
      content_tag :a, class: "page-link", href: link do
        "#{page_num}"
      end
    end
  end

  defp details(item, base_params) do
    for {key, title} <- base_params do
      case Map.get(item, key) do
        nil -> nil
        true -> {title, "Да"}
        false -> {title, "Нет"}
        val -> {title, val}
      end
    end
    |> Enum.filter(&(not is_nil(&1)))
  end
end

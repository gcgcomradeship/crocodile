defmodule Crocodile.Services.Telegram do
  use CrocodileWeb, :services

  alias Crocodile.Services.Telegram.Request
  alias Crocodile.TgChat

  def send_text(chat_id, text) do
    Request.post("sendMessage", %{chat_id: chat_id, text: text})
  end

  def order_alert(%{number: number, name: name, inserted_at: inserted_at}) do
    chats =
      TgChat
      |> where([t], t.approve == true)
      |> Repo.all()

    for chat <- chats do
      send_text(
        chat.chat_id,
        "Новый заказ! № #{number}(#{name}) / #{l(inserted_at, :date_time)}"
      )
    end
  end
end

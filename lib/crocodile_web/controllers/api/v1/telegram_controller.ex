defmodule CrocodileWeb.Api.V1.TelegramController do
  use CrocodileWeb, :controller

  alias Crocodile.TgChat
  alias Crocodile.Services.Telegram

  @webhook_token Application.get_env(:crocodile, :telegram)[:webhook_token]
  @tg_pass Application.get_env(:crocodile, :telegram)[:tgpass]

  def webhook(conn, %{"token" => token} = params) when token == @webhook_token do
    params
    |> check_tg_admin()
    |> check_pass(params)

    render(conn, "success.json")
  end

  def webhook(conn, _params) do
    render(conn, "success.json")
  end

  defp check_pass(chat, %{"message" => %{"text" => text}}) do
    case text == @tg_pass do
      true ->
        chat
        |> TgChat.changeset(%{approve: true})
        |> Repo.update()

        Telegram.send_text(chat.chat_id, "Вы авторизованы!")

      false ->
        nil
    end
  end

  defp check_pass(_, _), do: nil

  defp check_tg_admin(%{
         "message" => %{
           "chat" =>
             %{
               "id" => chat_id
             } = chat_params
         }
       }) do
    TgChat
    |> Repo.get_by(chat_id: chat_id)
    |> case do
      nil -> create_tg_chat(chat_params)
      chat -> chat
    end
  end

  defp check_tg_admin(_), do: nil

  defp create_tg_chat(params) do
    %TgChat{}
    |> TgChat.changeset(%{
      first_name: params["first_name"],
      chat_id: params["id"],
      last_name: params["last_name"],
      username: params["username"]
    })
    |> Repo.insert!()
  end
end

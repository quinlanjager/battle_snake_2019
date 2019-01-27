defmodule BattleSnake2019.Web.APIRouter do
  use Plug.Router
  import Poison
  alias BattleSnake2019.Snake

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  post "/start" do
    response = %{"color" => Snake.get_color()}
    send_resp(conn, 200, encode!(response))
  end

  post "/move" do
    body = conn.body_params
    my_snake = body["you"]
    other_snakes = body["board"]["snakes"]

    response_body = encode!(Snake.move())
    send_resp(conn, 200, response_body)
  end

  post "/end" do
    send_resp(conn, 200, "")
  end

  post "/ping" do
    send_resp(conn, 200, "")
  end
end

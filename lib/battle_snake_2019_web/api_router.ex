defmodule BattleSnake2019.Web.APIRouter do
  use Plug.Router
  import Poison
  alias BattleSnake2019.Snake
  alias BattleSnake2019.GameServer

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  post "/start" do
    response = %{"color" => Snake.get_color()}
    body = conn.body_params
    game_id = body["game"]["id"]

    GameServer.put(:game_server, game_id, body)

    send_resp(conn, 200, encode!(response))
  end

  post "/move" do
    body = conn.body_params
    game_id = body["game"]["id"]

    GameServer.put(:game_server, game_id, body)

    response_body = encode!(Snake.move())
    send_resp(conn, 200, response_body)
  end

  post "/end" do
    body = conn.body_params
    game_id = body["game"]["id"]

    GameServer.delete(:game_server, game_id)

    send_resp(conn, 200, "")
  end

  post "/ping" do
    send_resp(conn, 200, "")
  end
end

defmodule BattleSnake2019.Web.APIRouter do
  use Plug.Router
  import Jason
  alias BattleSnake2019.Field
  alias BattleSnake2019.Snake
  alias BattleSnake2019.GameServer

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  if System.get_env("DEBUG") do
    plug(Plug.Logger)
  end

  plug(:match)
  plug(:dispatch)

  post "/start" do
    response = %{"color" => Snake.get_color()}
    game = conn.body_params

    send_resp(conn, 200, encode!(response))
  end

  post "/move" do
    game = conn.body_params

    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)

    response_body = encode!(Snake.move(game_with_field))
    send_resp(conn, 200, response_body)
  end

  post "/end" do
    body = conn.body_params
    game_id = body["game"]["id"]

    send_resp(conn, 200, "")
  end

  post "/ping" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Resource not found")
  end
end

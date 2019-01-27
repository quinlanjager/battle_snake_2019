defmodule BattleSnake2019.Web.APIRouter do
  use Plug.Router
  import Poison

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  post "/echo" do
    body = conn.body_params()
    send_resp(conn, 200, Poison.encode!(body))
  end
end

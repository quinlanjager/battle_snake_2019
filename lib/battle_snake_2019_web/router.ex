defmodule BattleSnake2019.Web.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/api", to: BattleSnake2019.Web.APIRouter)

  match(_, do: send_resp(conn, 404, "Resource not found"))
end

defmodule BattleSnake2019.Web.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "Resource not found")
  end
end

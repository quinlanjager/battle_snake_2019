defmodule BattleSnake2019.Web.APIRouterTest do
  use ExUnit.Case
  use Plug.Test
  alias BattleSnake2019.Snake
  import Poison

  test "it responds to a start request with a colour" do
    conn = conn(:post, "/start") |> put_req_header("content-type", "application/json")
    options = BattleSnake2019.Web.APIRouter.init([])

    resp = BattleSnake2019.Web.APIRouter.call(conn, options)

    assert resp.state == :sent
    assert resp.status == 200

    {:ok, decoded_body} = decode(resp.resp_body)

    assert decoded_body == %{"color" => Snake.get_color()}
  end

  test "it responds to a move request with a move" do
    valid_moves = Snake.get_valid_moves()
    conn = conn(:post, "/move") |> put_req_header("content-type", "application/json")
    options = BattleSnake2019.Web.APIRouter.init([])
    resp = BattleSnake2019.Web.APIRouter.call(conn, options)

    assert resp.state == :sent
    assert resp.status == 200

    {:ok, decoded_body} = decode(resp.resp_body)

    assert %{"move" => move} = decoded_body
    assert Enum.member?(valid_moves, move) == true
  end

  test "it responds with a 200 when an end request is send" do
    conn = conn(:post, "/end") |> put_req_header("content-type", "application/json")
    options = BattleSnake2019.Web.APIRouter.init([])
    resp = BattleSnake2019.Web.APIRouter.call(conn, options)

    assert resp.state == :sent
    assert resp.status == 200
  end

  test "it responds with a 200 when pinged" do
    conn = conn(:post, "/ping") |> put_req_header("content-type", "application/json")
    options = BattleSnake2019.Web.APIRouter.init([])
    resp = BattleSnake2019.Web.APIRouter.call(conn, options)

    assert resp.state == :sent
    assert resp.status == 200
  end
end

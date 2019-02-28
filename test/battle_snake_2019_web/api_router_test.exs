defmodule BattleSnake2019.Web.APIRouterTest do
  use ExUnit.Case
  use Plug.Test
  alias BattleSnake2019.Snake
  import Jason

  @opts BattleSnake2019.Web.APIRouter.init([])

  describe "/start" do
    test "it responds to a start request with a colour" do
      conn = post_to_endpoint("/start", mock_start())
      resp = BattleSnake2019.Web.APIRouter.call(conn, @opts)

      assert resp.state == :sent
      assert resp.status == 200

      {:ok, decoded_body} = decode(resp.resp_body)

      assert decoded_body == %{
               "color" => Snake.get_color(),
               "headType" => Snake.get_head_type(),
               "tailType" => Snake.get_tail_type()
             }
    end
  end

  describe "/move" do
    test "it responds to a move request with a move" do
      valid_moves = Snake.get_valid_moves()

      conn = post_to_endpoint("/move", mock_start())
      resp = BattleSnake2019.Web.APIRouter.call(conn, @opts)

      assert resp.state == :sent
      assert resp.status == 200

      {:ok, decoded_body} = decode(resp.resp_body)

      assert %{"move" => move} = decoded_body
      assert Enum.member?(valid_moves, move) == true
    end
  end

  describe "/end" do
    test "it responds with a 200 when an end request is send" do
      conn = post_to_endpoint("/end")
      resp = BattleSnake2019.Web.APIRouter.call(conn, @opts)

      assert resp.state == :sent
      assert resp.status == 200
    end
  end

  test "it responds with a 200 when pinged" do
    conn = conn(:post, "/ping") |> put_req_header("content-type", "application/json")
    resp = BattleSnake2019.Web.APIRouter.call(conn, @opts)

    assert resp.state == :sent
    assert resp.status == 200
  end

  defp post_to_endpoint(endpoint) do
    conn(:post, endpoint) |> put_req_header("content-type", "application/json")
  end

  defp post_to_endpoint(endpoint, payload) do
    conn(:post, endpoint, encode!(payload)) |> put_req_header("content-type", "application/json")
  end

  # @TODO move this to a fixtures file
  defp mock_start do
    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 4,
      "board" => %{
        "height" => 15,
        "width" => 15,
        "food" => [
          %{
            "x" => 2,
            "y" => 3
          }
        ],
        "snakes" => [
          %{
            "id" => "snake-id-string",
            "name" => "Sneky Snek",
            "health" => 90,
            "body" => [
              %{
                "x" => 1,
                "y" => 3
              },
              %{
                "x" => 1,
                "y" => 3
              }
            ]
          }
        ]
      },
      "you" => %{
        "id" => "snake-id-string",
        "name" => "Sneky Snek",
        "health" => 90,
        "body" => [
          %{
            "x" => 1,
            "y" => 3
          },
          %{
            "x" => 1,
            "y" => 3
          }
        ]
      }
    }
  end
end

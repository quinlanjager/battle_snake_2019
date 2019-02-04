defmodule BattleSnake2019.GameServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, games} = BattleSnake2019.GameServer.start_link([])
    %{games: games}
  end

  test "stores values by key", %{games: games} do
    game = make_game()
    game_id = game["game"]["id"]
    assert BattleSnake2019.GameServer.get(games, game_id) == nil

    BattleSnake2019.GameServer.put(games, game)
    got_game = BattleSnake2019.GameServer.get(games, game_id)
    assert got_game["game"]["id"] == "game-id-string"
  end

  def make_game do
    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 4,
      "board" => %{
        "height" => 3,
        "width" => 3,
        "food" => [
          %{
            "x" => 2,
            "y" => 2
          }
        ],
        "snakes" => [
          %{
            "id" => "snake-id-string",
            "name" => "Sneky Snek",
            "health" => 90,
            "body" => [
              %{
                "x" => 0,
                "y" => 2
              },
              %{
                "x" => 0,
                "y" => 1
              },
              %{
                "x" => 0,
                "y" => 0
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
            "x" => 0,
            "y" => 2
          },
          %{
            "x" => 0,
            "y" => 1
          },
          %{
            "x" => 0,
            "y" => 0
          }
        ]
      }
    }
  end
end

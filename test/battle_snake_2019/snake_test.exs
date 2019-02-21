defmodule BattleSnake2019.SnakeTest do
  alias BattleSnake2019.Snake
  alias BattleSnake2019.Field
  use ExUnit.Case

  test "can handle moving to tail with back against wall" do
    game = mock_start()
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert is_binary(Map.get(res, "move"))
  end

  test "hunts snake" do
    enemy_snake_body = [
      %{
        "x" => 0,
        "y" => 2
      },
      %{
        "x" => 0,
        "y" => 2
      }
    ]

    game = mock_hunt(enemy_snake_body)
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert Map.get(res, "move") == "down"
  end

  test "doesnt go for adjacent snake" do
    enemy_snake_body = [
      %{
        "x" => 1,
        "y" => 2
      },
      %{
        "x" => 0,
        "y" => 2
      },
      %{
        "x" => 0,
        "y" => 2
      }
    ]

    game = mock_hunt(enemy_snake_body)
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert Map.get(res, "move") != "up"
  end

  def mock_hunt(enemy_snake_body) do
    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 1,
      "board" => %{
        "height" => 15,
        "width" => 15,
        "food" => [],
        "snakes" => [
          %{
            "id" => "snake-id-string",
            "name" => "Sneky Snek",
            "health" => 100,
            "body" => [
              %{
                "x" => 1,
                "y" => 3
              },
              %{
                "x" => 0,
                "y" => 3
              },
              %{
                "x" => 0,
                "y" => 3
              }
            ]
          },
          %{
            "id" => "other-snake",
            "name" => "Sneky Snek",
            "health" => 100,
            "body" => enemy_snake_body
          }
        ]
      },
      "you" => %{
        "id" => "snake-id-string",
        "name" => "Sneky Snek",
        "health" => 100,
        "body" => [
          %{
            "x" => 1,
            "y" => 3
          },
          %{
            "x" => 0,
            "y" => 3
          },
          %{
            "x" => 0,
            "y" => 3
          }
        ]
      }
    }
  end

  def mock_start do
    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 1,
      "board" => %{
        "height" => 15,
        "width" => 15,
        "food" => [],
        "snakes" => [
          %{
            "id" => "snake-id-string",
            "name" => "Sneky Snek",
            "health" => 100,
            "body" => [
              %{
                "x" => 1,
                "y" => 3
              },
              %{
                "x" => 0,
                "y" => 3
              },
              %{
                "x" => 0,
                "y" => 3
              }
            ]
          }
        ]
      },
      "you" => %{
        "id" => "snake-id-string",
        "name" => "Sneky Snek",
        "health" => 100,
        "body" => [
          %{
            "x" => 1,
            "y" => 3
          },
          %{
            "x" => 0,
            "y" => 3
          },
          %{
            "x" => 0,
            "y" => 3
          }
        ]
      }
    }
  end
end

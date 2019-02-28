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

  describe "avoiding heads, and eating them" do
    test "only avoids snake heads that are larger" do
      enemy_snake_bodies = [
        [
          %{"x" => 0, "y" => 3},
          %{"x" => 0, "y" => 2},
          %{"x" => 0, "y" => 1}
        ],
        [
          %{"x" => 3, "y" => 2},
          %{"x" => 3, "y" => 1},
          %{"x" => 3, "y" => 0},
          %{"x" => 4, "y" => 0},
          %{"x" => 5, "y" => 0},
          %{"x" => 5, "y" => 1},
          %{"x" => 4, "y" => 1},
          %{"x" => 4, "y" => 2}
        ]
      ]

      my_snake = [
        %{"x" => 2, "y" => 3},
        %{"x" => 3, "y" => 3},
        %{"x" => 4, "y" => 3},
        %{"x" => 5, "y" => 3},
        %{"x" => 5, "y" => 2}
      ]

      food = [
        %{"x" => 1, "y" => 2}
      ]

      dimensions = {4, 6}

      game = mock_game(enemy_snake_bodies, my_snake, food, dimensions)

      field = Field.create_field(game) |> Field.update_field(game)
      game_with_field = Map.put(game, "field", field)
      res = Snake.move(game_with_field)
      assert Map.get(res, "move") == "left"
    end

    test "Avoids bigger heads when making emergency moves" do
      enemy_snake_bodies = [
        [
          %{"x" => 0, "y" => 3},
          %{"x" => 0, "y" => 2},
          %{"x" => 0, "y" => 1},
          %{"x" => 0, "y" => 0},
          %{"x" => 1, "y" => 0},
          %{"x" => 2, "y" => 0},
          %{"x" => 2, "y" => 1}
        ],
        [
          %{"x" => 3, "y" => 2},
          %{"x" => 3, "y" => 1},
          %{"x" => 3, "y" => 0}
        ]
      ]

      my_snake = [
        %{"x" => 2, "y" => 3},
        %{"x" => 3, "y" => 3},
        %{"x" => 4, "y" => 3},
        %{"x" => 5, "y" => 3},
        %{"x" => 5, "y" => 2}
      ]

      food = []

      dimensions = {4, 6}

      game = mock_game(enemy_snake_bodies, my_snake, food, dimensions)

      field = Field.create_field(game) |> Field.update_field(game)
      game_with_field = Map.put(game, "field", field)
      res = Snake.move(game_with_field)
      assert Map.get(res, "move") == "up"
    end

    test "doesnt go for adjacent snake" do
      enemy_snake_body = [
        [
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
      ]

      game = mock_game(enemy_snake_body)
      field = Field.create_field(game) |> Field.update_field(game)
      game_with_field = Map.put(game, "field", field)
      res = Snake.move(game_with_field)
      assert Map.get(res, "move") != "up"
    end
  end

  test "prefers tiles closer to tail in an emergency" do
    enemy_snake_bodies = [
      [
        %{"x" => 0, "y" => 3},
        %{"x" => 0, "y" => 2},
        %{"x" => 0, "y" => 1},
        %{"x" => 0, "y" => 0},
        %{"x" => 1, "y" => 0},
        %{"x" => 2, "y" => 0},
        %{"x" => 2, "y" => 1}
      ],
      [
        %{"x" => 3, "y" => 2},
        %{"x" => 3, "y" => 1},
        %{"x" => 3, "y" => 0}
      ]
    ]

    my_snake = [
      %{"x" => 2, "y" => 3},
      %{"x" => 3, "y" => 3},
      %{"x" => 4, "y" => 3},
      %{"x" => 5, "y" => 3},
      %{"x" => 5, "y" => 2}
    ]

    food = [
      %{"x" => 4, "y" => 2},
      %{"x" => 4, "y" => 1}
    ]

    game = mock_game(enemy_snake_bodies, my_snake, food, {4, 6})
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert Map.get(res, "move") == "up"
  end

  test "Makes an emergency move when a nil goal is received" do
    #  012 
    # 0ob
    # 1bb
    # 2
    snake = [
      %{"x" => 0, "y" => 0},
      %{"x" => 1, "y" => 0},
      %{"x" => 0, "y" => 1},
      %{"x" => 1, "y" => 1}
    ]

    game = mock_game([], snake, [], {3, 3})
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert Map.get(res, "move") == "right"
  end

  test "avoids food around the walls" do
    #  0123 
    # 0b0 f
    # 1bb
    # 2 f
    # 3
    snake = [
      %{"x" => 1, "y" => 0},
      %{"x" => 0, "y" => 0},
      %{"x" => 0, "y" => 1},
      %{"x" => 1, "y" => 1}
    ]

    food = [
      %{"x" => 2, "y" => 2},
      %{"x" => 3, "y" => 0}
    ]

    game = mock_game([], snake, food, {4, 4})
    field = Field.create_field(game) |> Field.update_field(game)
    game_with_field = Map.put(game, "field", field)
    res = Snake.move(game_with_field)
    assert Map.get(res, "move") != "right"
  end

  def mock_game(
        enemy_snake_bodies,
        my_snake_body \\ [
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
        ],
        food \\ [],
        {height, width} \\ {15, 15}
      ) do
    snakes =
      Enum.map(enemy_snake_bodies, fn body ->
        %{
          "id" => "snake-#{:random.uniform(1000)}",
          "name" => "enemy",
          "health" => 100,
          "body" => body
        }
      end)

    you = %{
      "id" => "snake-id-string",
      "name" => "Sneky Snek",
      "health" => 100,
      "body" => my_snake_body
    }

    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 1,
      "board" => %{
        "height" => height,
        "width" => width,
        "food" => food,
        "snakes" => snakes ++ [you]
      },
      "you" => you
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

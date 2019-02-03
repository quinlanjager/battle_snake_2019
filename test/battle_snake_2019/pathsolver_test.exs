defmodule BattleSnake2019.PathsolverTest do
  use ExUnit.Case
  import BattleSnake2019.Pathsolver

  test "it finds food" do
    field = %{
      "1_1" => %{
        "x" => 1,
        "y" => 1,
        entity: "snake-id-string",
        segment_type: :tail
      },
      "1_2" => %{
        "x" => 1,
        "y" => 2,
        entity: "snake-id-string",
        segment_type: :body
      },
      "1_3" => %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :head
      },
      "2_1" => %{"x" => 2, "y" => 1},
      "2_2" => %{"x" => 2, "y" => 2},
      "2_3" => %{"x" => 2, "y" => 3, entity: :food, segment_type: nil},
      "3_1" => %{"x" => 3, "y" => 1},
      "3_2" => %{"x" => 3, "y" => 2},
      "3_3" => %{"x" => 3, "y" => 3}
    }

    game = Map.put(example_game(), "field", field)
    move = find_best_path_for_snake(game)
    assert move == "right"
  end

  test "finds best path to food" do
    field = %{
      "1_1" => %{
        "x" => 1,
        "y" => 1,
        entity: :food,
        segment_type: nil
      },
      "1_2" => %{
        "x" => 1,
        "y" => 2
      },
      "1_3" => %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :tail
      },
      "2_1" => %{"x" => 2, "y" => 1},
      "2_2" => %{"x" => 2, "y" => 2, entity: "snake-id-string", segment_type: :body},
      "2_3" => %{"x" => 2, "y" => 3, entity: :food, segment_type: nil},
      "3_1" => %{"x" => 3, "y" => 1},
      "3_2" => %{"x" => 3, "y" => 2, entity: "snake-id-string", segment_type: :body},
      "3_3" => %{"x" => 3, "y" => 3, entity: "snake-id-string", segment_type: :head}
    }

    game = Map.put(example_game(), "field", field)
    move = find_best_path_for_snake(game)
    assert move == "left"
  end

  defp example_game do
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
                "x" => 3,
                "y" => 3
              },
              %{
                "x" => 2,
                "y" => 3
              },
              %{
                "x" => 2,
                "y" => 2
              },
              %{
                "x" => 2,
                "y" => 2
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
          }
        ]
      }
    }
  end
end

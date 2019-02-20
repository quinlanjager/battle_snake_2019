defmodule BattleSnake2019.PathsolverTest do
  use ExUnit.Case
  import BattleSnake2019.Pathsolver

  test "it finds food" do
    field = [
      %{
        "x" => 1,
        "y" => 1,
        entity: "snake-id-string",
        segment_type: :tail,
        id: "1_1"
      },
      %{
        "x" => 1,
        "y" => 2,
        entity: "snake-id-string",
        segment_type: :body,
        id: "1_2"
      },
      %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :head,
        id: "1_3"
      },
      %{"x" => 2, "y" => 1, id: "2_1"},
      %{"x" => 2, "y" => 2, id: "2_2"},
      %{"x" => 2, "y" => 3, entity: :food, segment_type: nil, id: "2_3"},
      %{"x" => 3, "y" => 1, id: "3_1"},
      %{"x" => 3, "y" => 2, id: "3_2"},
      %{"x" => 3, "y" => 3, id: "3_3"}
    ]

    game = Map.put(example_game(), "field", field)
    goals = [%{"x" => 2, "y" => 3, entity: :food, segment_type: nil}]
    move = solve_shortest_path_to_goal(field, game["you"], goals)
    assert move == "right"
  end

  test "finds best path to food" do
    field = [
      %{
        "x" => 1,
        "y" => 1,
        entity: :food,
        segment_type: nil,
        id: "1_1"
      },
      %{
        "x" => 1,
        "y" => 2,
        id: "1_2"
      },
      %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :tail,
        id: "1_3"
      },
      %{"x" => 2, "y" => 1, id: "2_1"},
      %{"x" => 2, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "2_2"},
      %{"x" => 2, "y" => 3, entity: :food, segment_type: nil, id: "2_3"},
      %{"x" => 3, "y" => 1, id: "3_1"},
      %{"x" => 3, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "3_2"},
      %{"x" => 3, "y" => 3, entity: "snake-id-string", segment_type: :head, id: "3_3"}
    ]

    game = Map.put(example_game(), "field", field)
    goals = [%{"x" => 2, "y" => 3, entity: :food, segment_type: nil}]
    move = solve_shortest_path_to_goal(field, game["you"], goals)
    assert move == "left"
  end

  test "solves for one goal" do
    field = [
      %{
        "x" => 1,
        "y" => 1,
        entity: :food,
        segment_type: nil,
        id: "1_1"
      },
      %{
        "x" => 1,
        "y" => 2,
        id: "1_2"
      },
      %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :tail,
        id: "1_3"
      },
      %{"x" => 2, "y" => 1, id: "2_1"},
      %{"x" => 2, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "2_2"},
      %{"x" => 2, "y" => 3, entity: :food, segment_type: nil, id: "2_3"},
      %{"x" => 3, "y" => 1, id: "3_1"},
      %{"x" => 3, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "3_2"},
      %{"x" => 3, "y" => 3, entity: "snake-id-string", segment_type: :head, id: "3_3"}
    ]

    game = Map.put(example_game(), "field", field)
    goal = %{"x" => 2, "y" => 3, entity: :food, segment_type: nil}
    move = solve_shortest_path_to_goal(field, game["you"], goal)
    assert move == "left"
  end

  test "deprioritizes heads" do
    field = [
      %{
        "x" => 1,
        "y" => 1,
        entity: :food,
        segment_type: nil,
        id: "1_1"
      },
      %{
        "x" => 1,
        "y" => 2,
        id: "1_2"
      },
      %{
        "x" => 1,
        "y" => 3,
        entity: "snake-id-string",
        segment_type: :tail,
        id: "1_3"
      },
      %{"x" => 1, "y" => 4, id: "1_4"},
      %{"x" => 1, "y" => 5, id: "1_5"},
      %{"x" => 2, "y" => 1, entity: "snake-id-string", segment_type: :body, id: "2_1"},
      %{"x" => 2, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "2_2"},
      %{"x" => 2, "y" => 3, id: "2_3"},
      %{"x" => 2, "y" => 4, id: "2_4"},
      %{"x" => 2, "y" => 5, id: "2_5"},
      %{"x" => 3, "y" => 1, id: "3_1"},
      %{"x" => 3, "y" => 2, entity: "snake-id-string", segment_type: :body, id: "3_2"},
      %{"x" => 3, "y" => 3, entity: "snake-id-string", segment_type: :head, id: "3_3"},
      %{"x" => 3, "y" => 4, id: "3_4"},
      %{"x" => 3, "y" => 5, id: "3_5"},
      %{"x" => 4, "y" => 1, id: "4_1"},
      %{"x" => 4, "y" => 2, entity: :food, segment_type: nil, id: "4_2"},
      %{"x" => 4, "y" => 3, id: "4_3"},
      %{"x" => 4, "y" => 4, id: "4_4"},
      %{"x" => 4, "y" => 5, id: "4_5"},
      %{"x" => 5, "y" => 1, id: "5_1"},
      %{"x" => 5, "y" => 2, id: "5_2"},
      %{"x" => 5, "y" => 3, entity: "other-snake-id-string", segment_type: :head, id: "5_3"},
      %{"x" => 5, "y" => 4, id: "5_4"},
      %{"x" => 5, "y" => 5, id: "5_5"}
    ]

    game = Map.put(example_game(), "field", field)
    goal = %{"x" => 4, "y" => 2, entity: :food, segment_type: nil}
    move = solve_shortest_path_to_goal(field, game["you"], goal)
    assert move == "down"
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

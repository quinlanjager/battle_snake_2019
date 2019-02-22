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
    move = solve_shortest_path_to_goal(game, goals)
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
    move = solve_shortest_path_to_goal(game, goals)
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
    move = solve_shortest_path_to_goal(game, goal)
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

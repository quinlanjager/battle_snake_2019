defmodule BattleSnake2019.FieldTest do
  use ExUnit.Case
  import BattleSnake2019.Field

  test "creates a board" do
    %{"field" => field} = create_field(example_game())

    assert %{
             "1_1" => %{"x" => 1, "y" => 1},
             "1_2" => %{"x" => 1, "y" => 2},
             "1_3" => %{"x" => 1, "y" => 3},
             "2_1" => %{"x" => 2, "y" => 1},
             "2_2" => %{"x" => 2, "y" => 2},
             "2_3" => %{"x" => 2, "y" => 3},
             "3_1" => %{"x" => 3, "y" => 1},
             "3_2" => %{"x" => 3, "y" => 2},
             "3_3" => %{"x" => 3, "y" => 3}
           } = field
  end

  test "adds items" do
    %{"field" => field} = create_field(example_game())

    assert %{
             "1_1" => %{"x" => 1, "y" => 1},
             "1_2" => %{"x" => 1, "y" => 2},
             "1_3" => %{"x" => 1, "y" => 3},
             "2_1" => %{"x" => 2, "y" => 1},
             "2_2" => %{"x" => 2, "y" => 2},
             "2_3" => %{"x" => 2, "y" => 3},
             "3_1" => %{"x" => 3, "y" => 1},
             "3_2" => %{"x" => 3, "y" => 2},
             "3_3" => %{"x" => 3, "y" => 3}
           } = field

    updated_field = update_field(field, example_game())

    assert %{
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
             "2_2" => %{"x" => 2, "y" => 2, entity: :food, segment_type: nil},
             "2_3" => %{"x" => 2, "y" => 3},
             "3_1" => %{"x" => 3, "y" => 1},
             "3_2" => %{"x" => 3, "y" => 2},
             "3_3" => %{"x" => 3, "y" => 3}
           } = updated_field
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
                "x" => 1,
                "y" => 3
              },
              %{
                "x" => 1,
                "y" => 2
              },
              %{
                "x" => 1,
                "y" => 1
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

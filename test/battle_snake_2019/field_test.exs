defmodule BattleSnake2019.FieldTest do
  use ExUnit.Case
  import BattleSnake2019.Field

  test "creates a board" do
    field = create_field(example_game())

    assert [
             %{"x" => 0, "y" => 0},
             %{"x" => 1, "y" => 0},
             %{"x" => 2, "y" => 0},
             %{"x" => 0, "y" => 1},
             %{"x" => 1, "y" => 1},
             %{"x" => 2, "y" => 1},
             %{"x" => 0, "y" => 2},
             %{"x" => 1, "y" => 2},
             %{"x" => 2, "y" => 2}
           ] = field
  end

  test "adds items" do
    field = create_field(example_game())

    assert [
             %{"x" => 0, "y" => 0},
             %{"x" => 1, "y" => 0},
             %{"x" => 2, "y" => 0},
             %{"x" => 0, "y" => 1},
             %{"x" => 1, "y" => 1},
             %{"x" => 2, "y" => 1},
             %{"x" => 0, "y" => 2},
             %{"x" => 1, "y" => 2},
             %{"x" => 2, "y" => 2}
           ] = field

    updated_field = update_field(field, example_game())

    assert [
             %{
               :entity => "snake-id-string",
               :segment_type => :tail,
               "x" => 0,
               "y" => 0
             },
             %{"x" => 1, "y" => 0},
             %{"x" => 2, "y" => 0},
             %{
               :entity => "snake-id-string",
               :segment_type => :body,
               "x" => 0,
               "y" => 1
             },
             %{"x" => 1, "y" => 1},
             %{"x" => 2, "y" => 1},
             %{
               :entity => "snake-id-string",
               :segment_type => :head,
               "x" => 0,
               "y" => 2
             },
             %{"x" => 1, "y" => 2},
             %{:entity => :food, :segment_type => nil, "x" => 2, "y" => 2}
           ] = updated_field
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

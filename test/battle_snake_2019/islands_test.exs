defmodule BattleSnake2019.IslandsTest do
  use ExUnit.Case
  alias BattleSnake2019.Islands
  alias BattleSnake2019.Field

  test "generates islands from field" do
    #      0 1 2 3 4
    #    0 x 1 x x x
    #    1 x 1 1 1 x
    #    2 x 2 2 2 x
    #    3 2 2 x x x
    #    4 x x x x x

    snakes = [
      %{
        "id" => "1",
        "body" => [
          %{"x" => 3, "y" => 1},
          %{"x" => 2, "y" => 1},
          %{"x" => 1, "y" => 1},
          %{"x" => 1, "y" => 0}
        ]
      },
      %{
        "id" => "2",
        "body" => [
          %{"x" => 3, "y" => 2},
          %{"x" => 2, "y" => 2},
          %{"x" => 1, "y" => 2},
          %{"x" => 1, "y" => 3},
          %{"x" => 0, "y" => 3}
        ]
      }
    ]

    islands = [
      [
        %{:id => "0_0", "x" => 0, "y" => 0},
        %{
          :dist => 2.23606797749979,
          :entity => "1",
          :id => "1_0",
          :segment_type => :tail,
          "x" => 1,
          "y" => 0
        },
        %{:id => "0_1", "x" => 0, "y" => 1},
        %{:id => "2_0", "x" => 2, "y" => 0},
        %{:id => "0_2", "x" => 0, "y" => 2},
        %{:id => "3_0", "x" => 3, "y" => 0},
        %{
          :dist => 3.605551275463989,
          :entity => "2",
          :id => "0_3",
          :segment_type => :tail,
          "x" => 0,
          "y" => 3
        },
        %{:id => "4_0", "x" => 4, "y" => 0},
        %{
          :dist => 0.0,
          :entity => "1",
          :id => "3_1",
          :segment_type => :head,
          "x" => 3,
          "y" => 1
        },
        %{:id => "0_4", "x" => 0, "y" => 4},
        %{:id => "4_1", "x" => 4, "y" => 1},
        %{:id => "1_4", "x" => 1, "y" => 4},
        %{:id => "4_2", "x" => 4, "y" => 2},
        %{:id => "2_4", "x" => 2, "y" => 4},
        %{:id => "4_3", "x" => 4, "y" => 3},
        %{:id => "3_4", "x" => 3, "y" => 4},
        %{:id => "2_3", "x" => 2, "y" => 3},
        %{:id => "3_3", "x" => 3, "y" => 3},
        %{:id => "4_4", "x" => 4, "y" => 4}
      ]
    ]

    game = %{
      "board" => %{
        "snakes" => snakes,
        "food" => [],
        "height" => 5,
        "width" => 5
      },
      "you" => Enum.find(snakes, fn %{"id" => id} -> id == "1" end)
    }

    field =
      Field.create_field(game)
      |> Field.update_field(game)

    island_result = Islands.discover(Map.put(game, "field", field))

    assert island_result == islands
  end
end

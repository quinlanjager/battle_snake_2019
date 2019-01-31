defmodule BattleSnake2019.PathsolverTest do
  use ExUnit.Case
  import BattleSnake2019.Pathsolver

  test "it finds food" do
    board_with_food = [
      [%{"entity" => "snake-id-string", "segment_type" => :tail}, %{}, %{}],
      [
        %{"entity" => "snake-id-string", "segment_type" => :body},
        %{"entity" => :food, "segment_type" => nil},
        %{}
      ],
      [%{"entity" => "snake-id-string", "segment_type" => :head}, %{}, %{}]
    ]

    move = find_best_path_for_snake("snake-id-string", board_with_food)
    assert move == "right"
  end
end

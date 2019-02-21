defmodule BattleSnake2019.Snake.BodyTest do
  use ExUnit.Case
  alias BattleSnake2019.Snake.Body
  alias BattleSnake2019.Field

  test "finds false tail" do
    snake = %{
      "body" => [
        %{"x" => 2, "y" => 4},
        %{"x" => 3, "y" => 4},
        %{"x" => 2, "y" => 3},
        %{"x" => 2, "y" => 3}
      ],
      "id" => "snake"
    }

    game = %{
      "board" => %{
        "height" => 10,
        "width" => 10,
        "food" => [],
        "snakes" => [snake]
      },
      "you" => snake
    }

    field =
      Field.create_field(game)
      |> Field.update_field(game)

    tail = Body.get_false_tail(snake, field)
    assert tail == %{"x" => 1, "y" => 3, entity: "snake", segment_type: :tail, id: "1_3"}
  end
end

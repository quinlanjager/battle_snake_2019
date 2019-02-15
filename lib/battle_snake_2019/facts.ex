defmodule BattleSnake2019.Facts do
  alias BattleSnake2019.Field.Food
  alias BattleSnake2019.Field.Snake

  def get_facts(%{"field" => field, "you" => snake}) do
    all_food = Food.get_nodes(field)
    safe_food = Food.get_safe_nodes(field)

    %{
      health: snake["health"],
      all_food: all_food,
      safe_food: safe_food,
      safe_food_length: length(safe_food),
      all_food_length: length(all_food),
      # value needs to be an array
      tail: [Snake.get_segment_location(field, snake["id"], :tail)],
      body_size: length(snake["body"])
    }
  end
end

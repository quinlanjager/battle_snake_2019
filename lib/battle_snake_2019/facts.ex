defmodule BattleSnake2019.Facts do
  alias BattleSnake2019.Field.Food
  alias BattleSnake2019.Field.Snake

  def get_facts(%{"field" => field, "you" => snake}) do
    all_food = Food.get_nodes(field)
    safe_food = Food.get_safe_nodes(field)
    tail = Snake.get_segment_location(field, snake["id"], :tail)
    nearest_safe_food = Enum.sort_by(safe_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0)
    nearest_food = Enum.sort_by(all_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0)

    %{
      health_lost: snake["health"] - 100,
      safe_food_length: length(safe_food),
      all_food_length: length(all_food),
      body_size: length(snake["body"]),
      nearest_safe_food_dist: nearest_safe_food.dist,
      nearest_food_dist: nearest_food.dist,
      all_food: all_food,
      safe_food: safe_food,
      tai: [tail]
    }
  end
end

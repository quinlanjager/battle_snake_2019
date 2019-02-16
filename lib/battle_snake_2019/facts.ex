defmodule BattleSnake2019.Facts do
  alias BattleSnake2019.Field.Food
  alias BattleSnake2019.Field.Snake
  alias BattleSnake2019.Field.Nodes

  def get_facts(%{"field" => field, "you" => snake}) do
    snake_segment_types = Snake.get_segment_types()

    all_food = Food.get_nodes(field)

    ok_food =
      Enum.filter(all_food, fn food ->
        Nodes.calculate_node_safety(field, food, snake_segment_types) < 3 and
          Nodes.calculate_node_safety(field, food, snake_segment_types) > 0
      end)

    safe_food =
      Enum.filter(
        all_food,
        fn food ->
          Nodes.calculate_node_safety(field, food, snake_segment_types) == 0
        end
      )

    tail = Snake.get_segment_location(field, snake["id"], :tail)

    nearest_safe_food =
      Enum.sort_by(safe_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0, %{})

    nearest_food = Enum.sort_by(ok_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0, %{})
    # subtracting 1 because at least one body
    # node will be adjacent to the tail

    tail_is_hidden = if is_nil(tail), do: 1, else: 0

    tail_safety =
      if tail_is_hidden == 1,
        do: 1,
        else: Nodes.calculate_node_safety(field, tail, snake_segment_types) - 1

    %{
      health_lost: snake["health"] - 100,
      safe_food_length: length(safe_food),
      all_food_length: length(ok_food),
      body_size: length(snake["body"]),
      nearest_safe_food_dist: Map.get(nearest_safe_food, :dist, 0),
      nearest_food_dist: Map.get(nearest_food, :dist, 0),
      all_food: {ok_food, :short},
      safe_food: {safe_food, :short},
      tail: {[tail], :short},
      # on the first turn the tail is "stacked"
      tail_safety: max(tail_safety, 1),
      tail_is_hidden: tail_is_hidden
    }
  end
end

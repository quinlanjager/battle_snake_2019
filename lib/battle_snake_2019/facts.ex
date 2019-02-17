defmodule BattleSnake2019.Facts do
  alias BattleSnake2019.Field.Food
  alias BattleSnake2019.Field.Snake
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Snake.Body

  def get_facts(%{"field" => field, "you" => snake, "board" => %{"snakes" => snakes}}) do
    snake_segment_types = Snake.get_segment_types()
    body_size = Body.get_body_size(snake)
    enemy_snakes = Body.find_enemy_snakes(snake, snakes)
    no_of_enemy_snakes = length(enemy_snakes)

    {enemy_head, enemy_head_distance, enemy_body_size} =
      Enum.at(enemy_snakes, 0, {%{entity: :snake}, 1000, 1000})

    enemy_body_difference = body_size - enemy_body_size
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
      Enum.sort_by(safe_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0, %{entity: :food})

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
      body_size: body_size,
      nearest_safe_food_dist: Map.get(nearest_safe_food, :dist, 0),
      nearest_food_dist: Map.get(nearest_food, :dist, 0),
      all_food: {ok_food, :short},
      safe_food: {safe_food, :short},
      tail: {tail, :short},
      # on the first turn the tail is "stacked"
      tail_safety: max(tail_safety, 1),
      tail_is_hidden: tail_is_hidden,
      no_of_enemy_snakes: no_of_enemy_snakes,
      enemy_body_difference: enemy_body_difference,
      enemy_head_distance: enemy_head_distance,
      enemy_head: {enemy_head, :short}
    }
  end
end

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

    {enemy_head, enemy_head_distance, enemy_body_size, is_adjacent_enemy} =
      Enum.at(enemy_snakes, 0, {%{entity: :snake}, 100_000, 0, false})

    {_largest_enemy_head, _largest_enemy_distance, largest_enemy_body_size,
     _is_adjacent_enemy_large} =
      Enum.sort_by(enemy_snakes, fn {_, _, body_size, _} -> body_size end, &>=/2)
      |> Enum.at(0, {%{entity: :snake}, 100_000, 0, false})

    # if they are the same size, treat
    # as if it's 1 bigger
    enemy_body_difference =
      if body_size - enemy_body_size == 0, do: -1, else: body_size - enemy_body_size

    largest_body_difference =
      if body_size - largest_enemy_body_size == 0,
        do: -1,
        else: body_size - largest_enemy_body_size

    enemy_head_is_adjacent = if is_adjacent_enemy, do: 1, else: 0

    no_of_enemy_nearby =
      Enum.count(
        enemy_snakes,
        fn {_enemy_head, enemy_head_distance, _enemy_body_size, _is_adjacent_enemy} ->
          enemy_head_distance < 4
        end
      )

    enemy_body_difference = body_size - enemy_body_size

    head = Snake.get_segment_location(field, snake["id"], :head)
    maybe_tail = Snake.get_segment_location(field, snake["id"], :tail)

    tail = if is_nil(maybe_tail), do: Body.get_false_tail(snake, field), else: maybe_tail

    no_tail = if is_nil(tail), do: 1, else: 0

    {ok_food_result, safe_food_result} = find_food_facts(field, snake_segment_types, snake)

    no_ok_food = if length(ok_food_result) < 1, do: 1, else: 0
    no_safe_food = if length(safe_food_result) < 1, do: 1, else: 0

    nearest_safe_food =
      Enum.sort_by(safe_food_result, fn %{dist: dist} -> dist end, &<=/2)
      |> Enum.at(0, %{entity: :food})

    nearest_food =
      Enum.sort_by(ok_food_result, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0, %{})

    ok_food = if no_ok_food == 1 and no_tail == 0, do: [tail], else: ok_food_result
    safe_food = if no_safe_food == 1 and no_tail == 0, do: [tail], else: safe_food_result

    # subtracting 1 because at least one body
    # node will be adjacent to the tail

    snake_safety = Nodes.calculate_node_safety(field, head, snake_segment_types) - 1

    tail_safety =
      if no_tail == 1,
        do: 1,
        else: Nodes.calculate_node_safety(field, tail, snake_segment_types) - 1

    %{
      health_lost: 100 - snake["health"],
      safe_food_length: length(safe_food),
      all_food_length: length(ok_food),
      no_ok_food: no_ok_food,
      no_safe_food: no_safe_food,
      body_size: body_size,
      nearest_safe_food_dist: Map.get(nearest_safe_food, :dist, 0),
      nearest_food_dist: Map.get(nearest_food, :dist, 0),
      all_food: {ok_food, :short},
      safe_food: {safe_food, :short},
      tail: {tail, :short},
      # on the first turn the tail is "stacked"
      tail_safety: max(tail_safety, 1),
      no_tail: no_tail,
      no_of_enemy_snakes: no_of_enemy_snakes,
      no_of_enemy_nearby: no_of_enemy_nearby,
      largest_body_difference: largest_body_difference,
      enemy_body_difference: enemy_body_difference,
      enemy_head_distance: enemy_head_distance,
      enemy_head: {enemy_head, :short},
      enemy_head_is_adjacent: enemy_head_is_adjacent,
      snake_safety: snake_safety
    }
  end

  def find_food_facts(field, snake_segment_types, snake) do
    all_food = Food.get_nodes(field)

    ok_food =
      Enum.filter(all_food, fn food ->
        # TODO have this think criticaly re: size of snake
        !Nodes.is_segment_adjacent_node?(field, food, :head, [snake["id"]]) and
          Nodes.calculate_node_safety(field, food, snake_segment_types) < 3
      end)

    safe_food =
      Enum.filter(
        all_food,
        fn food ->
          !Nodes.is_segment_adjacent_node?(field, food, :head, [snake["id"]]) and
            Nodes.calculate_node_safety(field, food, snake_segment_types) == 0
        end
      )

    {ok_food, safe_food}
  end
end

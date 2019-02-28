defmodule BattleSnake2019.Facts do
  alias BattleSnake2019.Field.Food
  alias BattleSnake2019.Field.Snake
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Snake.Body
  alias BattleSnake2019.Islands

  def get_facts(%{"field" => field, "you" => snake} = game) do
    islands = Islands.discover(game)
    snake_segment_types = Snake.get_segment_types()
    body_size = Body.get_body_size(snake)

    head = Snake.get_segment_location(field, snake["id"], :head)

    snake_safety = Nodes.calculate_node_safety(field, head, snake_segment_types) - 1

    {no_of_enemy_snakes, enemy_head, enemy_body_difference, largest_body_difference,
     enemy_head_is_adjacent, no_of_enemy_nearby,
     enemy_head_distance} = find_enemy_facts(game, islands)

    {no_ok_food, no_safe_food, no_all_food, skip_all_food, ok_food_result, safe_food_result,
     all_food_result} = find_food_facts(game, islands)

    {tail, no_tail} = find_tail_facts(game)

    all_food = if no_all_food == 1 and no_tail == 0, do: [tail], else: all_food_result
    ok_food = if no_ok_food == 1 and no_tail == 0, do: [tail], else: ok_food_result
    safe_food = if no_safe_food == 1 and no_tail == 0, do: [tail], else: safe_food_result

    %{
      health_lost: 100 - snake["health"],
      all_food_length: length(all_food),
      safe_food_length: length(safe_food),
      ok_food_length: length(ok_food),
      no_all_food: no_all_food,
      no_ok_food: no_ok_food,
      no_safe_food: no_safe_food,
      skip_all_food: skip_all_food,
      body_size: body_size,
      all_food: {all_food, :short},
      ok_food: {ok_food, :short},
      safe_food: {safe_food, :short},
      tail: {tail, :short},
      no_tail: no_tail,
      no_of_enemy_nearby: no_of_enemy_nearby,
      largest_body_difference: largest_body_difference,
      enemy_body_difference: enemy_body_difference,
      enemy_head_distance: enemy_head_distance,
      enemy_head: {enemy_head, :short},
      enemy_head_is_adjacent: enemy_head_is_adjacent
    }
  end

  def find_food_facts(
        %{"field" => field, "you" => snake, "board" => %{"snakes" => snakes}},
        islands
      ) do
    snake_segment_types = Snake.get_segment_types()
    snake_head = Snake.get_segment_location(field, snake["id"], :head)

    all_food =
      Food.get_nodes(field)
      |> Enum.filter(fn food ->
        Snake.count_deadly_adjacent_snake_heads(field, food, snakes, snake["id"]) == 0 and
          Islands.is_in_same_island?(islands, food, snake_head)
      end)

    ok_food =
      Enum.filter(all_food, fn food ->
        Nodes.calculate_node_safety(field, food, snake_segment_types) < 3 and
          !Nodes.is_node_adjacent_to_wall?(field, food)
      end)

    safe_food =
      Enum.filter(
        ok_food,
        fn food ->
          Nodes.calculate_node_safety(field, food, snake_segment_types) == 0
        end
      )

    skip_all_food = if length(ok_food) > 0 or length(safe_food) > 0, do: 1, else: 0
    no_all_food = if length(all_food) < 1, do: 1, else: 0
    no_ok_food = if length(ok_food) < 1, do: 1, else: 0
    no_safe_food = if length(safe_food) < 1, do: 1, else: 0

    nearest_safe_food =
      Enum.sort_by(safe_food, fn %{dist: dist} -> dist end, &<=/2)
      |> Enum.at(0, %{entity: :food})

    nearest_food = Enum.sort_by(ok_food, fn %{dist: dist} -> dist end, &<=/2) |> Enum.at(0, %{})

    {no_ok_food, no_safe_food, skip_all_food, no_all_food, ok_food, safe_food, all_food}
  end

  def find_enemy_facts(
        %{"field" => field, "you" => snake, "board" => %{"snakes" => snakes}},
        islands
      ) do
    snake_head = Snake.get_segment_location(field, snake["id"], :head)
    body_size = Body.get_body_size(snake)

    enemy_snakes = Body.find_enemy_snakes(field, snake, snakes)

    no_of_enemy_snakes = length(enemy_snakes)

    {enemy_head, enemy_head_distance, enemy_body_size, is_adjacent_enemy} =
      Enum.filter(enemy_snakes, fn {enemy_head, _, _, _} ->
        node_is_safe =
          Nodes.calculate_node_safety(field, enemy_head, [:body]) == 0 and
            Snake.count_deadly_adjacent_snake_heads(field, enemy_head, snakes, snake["id"]) == 0

        node_is_safe and Islands.is_in_same_island?(islands, enemy_head, snake_head)
      end)
      |> Enum.at(0, {%{entity: :snake}, 100_000, 0, false})

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

    {no_of_enemy_snakes, enemy_head, enemy_body_difference, largest_body_difference,
     enemy_head_is_adjacent, no_of_enemy_nearby, enemy_head_distance}
  end

  def find_tail_facts(
        %{"field" => field, "you" => snake, "board" => %{"snakes" => snakes}} = game
      ) do
    maybe_tail = Snake.get_segment_location(field, snake["id"], :tail)

    tail = if is_nil(maybe_tail), do: Body.get_false_tail(snake, game), else: maybe_tail

    no_tail = if is_nil(tail), do: 1, else: 0

    {tail, no_tail}
  end
end

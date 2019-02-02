defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Snake
  import BattleSnake2019.Field
  import BattleSnake2019.Nodes

  def find_best_path_for_snake(%{"field" => field, "you" => snake}) do
    field_coords = Map.values(field)

    start = get_head_location(snake)

    sorted_food = find_nearest_food(field, start)

    snake_tail = get_tail_location(snake)

    # tail: snake_tail, 
    goals = [food: sorted_food]

    # tail: direction_to_tail, 
    [food: direction_to_food] =
      Task.async_stream(goals, fn goal ->
        find_path_to_goal(start, goal, snake_tail, field)
      end)
      |> Enum.reduce([], fn {:ok, result}, soFar -> soFar ++ [result] end)

    # else: direction_to_tail
    if direction_to_food, do: direction_to_food
  end

  defp find_path_to_goal(start, {item_type, [goal | rest]}, tail, field) do
    open_list = [Map.merge(goal, %{cost: 0})]
    closed_list = []

    result = collect_waypoints_to_goal(start, open_list, closed_list, field)

    case result do
      [true, waypoints, start: start] ->
        sorted_points = waypoints |> Enum.sort_by(&(&1.cost >= &1.cost))
        direction = find_best_tile(sorted_points, start)
        {item_type, direction}

      [false, _waypoints] ->
        find_path_to_goal(start, {item_type, rest}, tail, field)
    end
  end

  defp find_path_to_goal(start, {item_type, []}, tail, field_coords) do
    [item_type, false]
  end

  defp collect_waypoints_to_goal(start, [current_tile | rest], closed_list, field) do
    case is_the_node?(start, current_tile) do
      true ->
        [true, closed_list, start: current_tile]

      false ->
        updated_closed_list = closed_list ++ [current_tile]

        nearby_list =
          get_adjacent_nodes_and_cost(field, current_tile)
          |> Enum.filter(fn tile -> keep_tile?(tile, rest) end)

        updated_open_list = rest ++ nearby_list
        found_start? = Enum.find(nearby_list, fn tile -> is_the_node?(start, tile) end)

        if found_start?,
          do: [
            true,
            updated_closed_list,
            start: Map.put(start, :cost, current_tile.cost + 1)
          ],
          else: collect_waypoints_to_goal(start, updated_open_list, updated_closed_list, field)
    end
  end

  # If we got to this point, we couldn't find the start!! NEW PLAN!!
  # GO HAMILTONIAN
  defp collect_waypoints_to_goal(_start, [], closed_list, _field), do: [false, closed_list]

  defp find_best_tile([node | waypoints], start) do
    if node.cost >= start.cost,
      do: find_best_tile(waypoints, start),
      else: get_direction_to_node(start, node)
  end

  def add_cost(%{"x" => x, "y" => y}, tile) do
    tile_is_start = tile["x"] == x and tile["y"] == y
    cost = if tile_is_start, do: 0, else: 1
    Map.merge(tile, %{cost: cost})
  end

  def keep_tile?(
        %{"x" => x, "y" => y, segment_type: segment_type, cost: cost} = waypoint,
        closed_list
      ) do
    tile_is_tail = segment_type == :tail
    tile_is_food = segment_type == :food

    found_better_waypoint = !there_a_better_waypoint?(waypoint, closed_list)

    tile_is_food or tile_is_tail or found_better_waypoint
  end

  def keep_tile?(nil, _closed_list), do: false

  def keep_tile?(waypoint, closed_list), do: !there_a_better_waypoint?(waypoint, closed_list)

  defp there_a_better_waypoint?(%{"x" => x, "y" => y, :cost => cost}, closed_list) do
    Enum.any?(closed_list, fn closed_tile ->
      has_same_coordinate = closed_tile["x"] == x or closed_tile["y"] == y
      has_same_cost_or_better = closed_tile.cost <= cost
      has_same_cost_or_better and has_same_coordinate
    end)
  end
end

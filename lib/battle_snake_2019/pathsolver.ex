defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Food
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Pathsolver.Waypoints

  def find_best_path_for_snake(%{"field" => field, "you" => snake}) do
    my_id = snake["id"]
    start = get_segment_location(field, my_id, :head)
    snake_tail = get_segment_location(field, my_id, :tail)
    nearest_food = find_nearest_food(field, start)

    # tail: snake_tail, 
    goals = [food: nearest_food]

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
        sorted_points = get_adjacent_nodes(waypoints, start) |> Enum.sort_by(& &1.cost, &>=/2)
        direction = find_best_waypoint(sorted_points, start)
        {item_type, direction}

      [false, _waypoints] ->
        find_path_to_goal(start, {item_type, rest}, tail, field)
    end
  end

  defp find_path_to_goal(_start, {item_type, []}, _tail, _field_coords) do
    {item_type, false}
  end
end

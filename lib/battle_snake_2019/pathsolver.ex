defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Food
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Pathsolver.Waypoints

  def find_best_path_for_snake(%{"field" => field, "you" => snake}) do
    my_id = snake["id"]
    start = get_segment_location(field, my_id, :head)
    snake_tail = get_segment_location(field, my_id, :tail)
    IO.puts("snake")
    IO.inspect(snake)
    nearest_food = find_nearest_food(field, start)
    IO.puts("nearest_food")
    IO.inspect(nearest_food)

    # tail: snake_tail, 
    goals = [food: nearest_food]

    # tail: direction_to_tail, 
    [direction_to_food | rest_of_directions] =
      Task.async_stream(goals, fn {goal_name, goal_coordinates} ->
        Task.async_stream(goal_coordinates, fn coordinate ->
          find_path_to_goal(start, {goal_name, coordinate}, snake_tail, field)
        end)
        |> Enum.reduce([], fn {:ok, result}, soFar -> soFar ++ [result] end)
      end)
      |> Enum.reduce([], fn {:ok, results}, soFar -> soFar ++ results end)
      |> List.flatten()
      |> Enum.filter(fn {code, _result} -> code == :ok end)
      |> Enum.sort_by(fn {:ok, {_direction, distance}} -> distance end, &<=/2)
      |> Enum.map(fn {:ok, {direction, _distance}} -> direction end)

    IO.puts(direction_to_food)
    # else: direction_to_tail
    if direction_to_food, do: direction_to_food
  end

  defp find_path_to_goal(start, {item_type, goal}, tail, field) do
    open_list = [Map.merge(goal, %{cost: 0})]
    closed_list = []

    result = collect_waypoints_to_goal(start, open_list, closed_list, field)

    case result do
      [true, waypoints, start: start] ->
        sorted_points = get_adjacent_nodes(waypoints, start) |> Enum.sort_by(& &1.cost, &>=/2)
        direction = find_best_waypoint(sorted_points, start)
        {:ok, {direction, goal.distance}}

      [false, waypoints] ->
        {:error, false}
    end
  end

  defp find_path_to_goal(_start, {item_type, []}, _tail, _field_coords) do
    {item_type, false}
  end
end

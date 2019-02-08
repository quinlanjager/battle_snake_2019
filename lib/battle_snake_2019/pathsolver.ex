defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Pathsolver.Waypoints

  def find_path_to_goal(field, snake, goal_spec) do
    snake_id = snake["id"]
    start = get_segment_location(field, snake_id, :head) |> Map.put(:cost, 0)

    unvisited_list = [Map.put(start, :cost, 0)]
    visited_list = []
    path = %{}
    IO.puts("finding goal")
    paths_to_goal = find_goal(field, start, goal_spec, unvisited_list, visited_list, path)
    IO.puts("paths_to_goal")
    IO.inspect(paths_to_goal)

    case paths_to_goal do
      {:ok, waypoints, goal} ->
        {:ok, result} = find_first_step_to_goal(start, goal, waypoints)

        get_waypoint_direction(result, start)

      {:error, message, _goal} ->
        IO.puts(message)
        # do something else :(
    end
  end

  def find_goal(field, start, goal_spec, [node | rest], visited_list, path) do
    is_same_type = is_same_node_type?(goal_spec, node)
    has_same_coordinates = is_the_node?(goal_spec, node)
    is_goal = is_same_type or has_same_coordinates

    unvisited_list =
      get_adjacent_nodes_and_cost(field, node)
      |> Enum.filter(fn waypoint -> keep_waypoint?(waypoint, visited_list) end)

    updated_path =
      Enum.reduce(unvisited_list, path, fn %{"x" => x, "y" => y}, soFar ->
        Map.put(soFar, "#{x}_#{y}", node)
      end)

    updated_visited_list = visited_list ++ [node]

    if is_goal do
      {:ok, path, node}
    else
      updated_unvisited_list = (rest ++ unvisited_list) |> Enum.sort_by(& &1.cost, &<=/2)

      find_goal(
        field,
        start,
        goal_spec,
        updated_unvisited_list,
        updated_visited_list,
        updated_path
      )
    end
  end

  def find_goal(_field, _start, goal_spec, [], _visited_list) do
    {:error, "couldn't find goal", goal_spec}
  end

  def find_first_step_to_goal(start, %{"x" => x, "y" => y} = maybe_first_step, waypoints) do
    parent = waypoints["#{x}_#{y}"]
    is_start = is_the_node?(parent, start)

    if is_start do
      {:ok, maybe_first_step}
    else
      find_first_step_to_goal(start, parent, waypoints)
    end
  end
end

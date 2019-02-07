defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Pathsolver.Waypoints

  def find_path_to_goal(field, snake, goal_spec) do
    snake_id = snake["id"]
    start = get_segment_location(field, snake_id, :head) |> Map.put(:cost, 0)

    unvisited_list = [Map.put(start, :cost, 0)]
    visited_list = []
    paths_to_goal = find_goal(field, start, goal_spec, unvisited_list, visited_list)

    case paths_to_goal do
      {:ok, waypoints} ->
        [goal | sorted_waypoints] = Enum.sort_by(waypoints, & &1.cost, &>=/2)
        path = []

        {:ok, results} = find_path_to_start(start, goal, sorted_waypoints, path)

        first_step = Enum.sort_by(results, & &1.cost, &<=/2) |> Enum.at(0)

        get_waypoint_direction(first_step, start)

      {:error, message} ->
        IO.puts(message)
        # do something else :(
    end
  end

  def find_goal(field, start, goal_spec, [node | rest], visited_list) do
    is_same_type = is_same_node_type?(goal_spec, node)
    has_same_coordinates = is_the_node?(goal_spec, node)
    is_goal = is_same_type or has_same_coordinates

    unvisited_list =
      get_adjacent_nodes_and_cost(field, start)
      |> Enum.filter(fn waypoint -> keep_waypoint?(waypoint, visited_list) end)

    updated_visited_list = visited_list ++ [node]
    updated_unvisited_list = (rest ++ unvisited_list) |> Enum.sort_by(& &1.cost, &<=/2)

    if is_goal,
      do: {:ok, updated_visited_list},
      else: find_goal(field, start, goal_spec, updated_unvisited_list, updated_visited_list)
  end

  def find_goal(_field, _start, goal_spec, [], _visited_list) do
    {:error, "couldn't find goal", goal_spec}
  end

  def find_path_to_start(start, current_step, [next_waypoint | rest], path) do
    is_adjacent = is_adjacent_node?(current_step, next_waypoint)
    has_lower_cost = current_step.cost > next_waypoint.cost
    is_start = is_the_node?(start, current_step)
    updated_path = if is_adjacent and has_lower_cost, do: path ++ [current_step]

    if is_start,
      # don't want the start node in the paths
      do: {:ok, path},
      else: find_path_to_start(start, next_waypoint, rest, updated_path)
  end

  def find_path_to_start(start, current_step, [], path) do
    is_start = is_the_node?(start, current_step)

    if is_start,
      # don't want the start node in the paths
      do: {:ok, path},
      else: {:error, "couldn't find start", start}
  end
end

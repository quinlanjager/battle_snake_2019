defmodule BattleSnake2019.Pathsolver do
  alias BattleSnake2019.Pathsolver.Path
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Field.Snake
  alias BattleSnake2019.Pathsolver.Waypoints

  def solve_shortest_path_to_goal(field, snake, goals) do
    snake_id = snake["id"]
    start = Snake.get_segment_location(field, snake_id, :head) |> Map.put(:cost, 0)

    paths_to_goal = find_ideal_path(field, start, goals)

    case paths_to_goal do
      {:ok, path, goal} ->
        # index 0 is the start
        Waypoints.get_waypoint_direction(Enum.at(path, 1), start)

      nil ->
        IO.puts("couldn't find goal")
        # do something else :(
    end
  end

  def solve_longest_path_to_goal(field, snake, goals) do
    snake_id = snake["id"]
    start = Snake.get_segment_location(field, snake_id, :head) |> Map.put(:cost, 0)
    paths_to_goal = find_ideal_path(field, start, goals)

    case paths_to_goal do
      {:ok, path, goal} ->
        extended_path = Path.extend_path(path, field)
        # index 0 is the start
        Waypoints.get_waypoint_direction(Enum.at(path, 1), start)

      nil ->
        IO.puts("couldn't find goal")
        # do something else :(
    end
  end

  def find_ideal_path(field, start, goals) do
    {_result_code, path_to_goal} =
      Task.async_stream(
        goals,
        fn goal ->
          unvisited_list = [Map.put(start, :cost, 0)]
          visited_list = []
          path = %{}

          paths_to_goal =
            solve_path_to_goal(field, start, goal, unvisited_list, visited_list, path)
        end,
        ordered: false,
        timeout: 200,
        on_timeout: :kill_task
      )
      |> Enum.find(
        {:error, nil},
        fn {message, {result_message, _waypoints, _goal}} ->
          result_message == :ok
        end
      )

    path_to_goal
  end

  def solve_path_to_goal(field, start, goal, [node | rest], visited_list, path) do
    has_same_coordinates = Nodes.is_the_node?(goal, node)
    is_goal = has_same_coordinates

    if is_goal do
      path_to_start = Path.trace_path(path, node, [node])
      {:ok, path_to_start, node}
    else
      unvisited_list =
        Nodes.get_adjacent_nodes(field, node)
        |> Enum.filter(fn waypoint ->
          Waypoints.keep_waypoint?(waypoint, visited_list, goal)
        end)
        |> Enum.map(fn waypoint ->
          Map.put(waypoint, :cost, Waypoints.get_cost(waypoint, node, goal))
        end)

      updated_path =
        Enum.reduce(unvisited_list, path, fn %{"x" => x, "y" => y} = waypoint, soFar ->
          Map.put(soFar, "#{x}_#{y}", node)
        end)

      updated_visited_list = visited_list ++ [node]
      updated_unvisited_list = (rest ++ unvisited_list) |> Enum.sort_by(& &1.cost, &<=/2)

      solve_path_to_goal(
        field,
        start,
        goal,
        updated_unvisited_list,
        updated_visited_list,
        updated_path
      )
    end
  end

  def solve_path_to_goal(_field, _start, goal_spec, [], _visited_list, _path) do
    {:error, "couldn't find goal", goal_spec}
  end
end

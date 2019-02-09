defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Pathsolver.Waypoints

  def find_path_to_goal(field, snake, goal_spec) do
    snake_id = snake["id"]
    start = get_segment_location(field, snake_id, :head) |> Map.put(:cost, 0)

    nodes_matching_spec =
      Enum.filter(field, fn node ->
        is_same_node_type?(node, goal_spec)
      end)

    {_result_code, paths_to_goal} =
      Task.async_stream(
        nodes_matching_spec,
        fn goal ->
          unvisited_list = [Map.put(start, :cost, 0)]
          visited_list = []
          path = %{}
          paths_to_goal = find_goal(field, start, goal, unvisited_list, visited_list, path)
        end,
        ordered: false,
        timeout: 50,
        on_timeout: :kill_task
      )
      |> Enum.filter(fn {message, _result} -> message != :error and message != :exit end)
      |> Enum.find(
        {:error, nil},
        fn {message, {result_message, _waypoints, _goal}} ->
          result_message == :ok
        end
      )

    case paths_to_goal do
      {:ok, path, goal} ->
        extended_path = extend_path(path, field)
        IO.inspect(extended_path)
        get_waypoint_direction(Enum.at(extended_path, 1), start)

      nil ->
        IO.puts("couldn't find goal")
        # do something else :(
    end
  end

  def find_goal(field, start, goal, [node | rest], visited_list, path) do
    has_same_coordinates = is_the_node?(goal, node)
    is_goal = has_same_coordinates

    if is_goal do
      path_to_start = find_path(path, node, [node])
      {:ok, path_to_start, node}
    else
      unvisited_list =
        get_adjacent_nodes(field, node)
        |> Enum.filter(fn waypoint -> keep_waypoint?(waypoint, visited_list) end)
        |> Enum.map(fn waypoint ->
          Map.put(waypoint, :cost, get_cost(waypoint, node, goal))
        end)

      updated_path =
        Enum.reduce(unvisited_list, path, fn %{"x" => x, "y" => y} = waypoint, soFar ->
          Map.put(soFar, "#{x}_#{y}", node)
        end)

      updated_visited_list = visited_list ++ [node]
      updated_unvisited_list = (rest ++ unvisited_list) |> Enum.sort_by(& &1.cost, &<=/2)

      find_goal(
        field,
        start,
        goal,
        updated_unvisited_list,
        updated_visited_list,
        updated_path
      )
    end
  end

  def find_goal(_field, _start, goal_spec, [], _visited_list) do
    {:error, "couldn't find goal", goal_spec}
  end

  def find_path(path, %{"x" => x, "y" => y}, path_so_far) do
    parent = Map.get(path, "#{x}_#{y}")

    if is_nil(parent) do
      path_so_far
    else
      find_path(path, parent, [parent | path_so_far])
    end
  end

  defp extend_path(path, field) do
    Enum.chunk_every(path, 2)
    |> Enum.map(fn paths ->
      extend_pair(paths, field)
    end)
    |> List.flatten()
  end

  defp extend_pair([path1, path2] = pair, field) do
    direction = get_waypoint_direction(path2, path1)

    directions_to_check =
      if direction == "left" or direction == "right" do
        ["up", "down"]
      else
        ["left", "right"]
      end

    pairs_to_add =
      Enum.map(directions_to_check, fn direction_to_check ->
        Enum.map(pair, fn path ->
          get_adjacent_node(field, path, direction_to_check)
        end)
      end)
      |> Enum.filter(fn [new_path_1, new_path_2] = set ->
        !Kernel.is_nil(new_path_1) and !Kernel.is_nil(new_path_2) and
          keep_waypoint?(new_path_1, []) and keep_waypoint?(new_path_2, [])
      end)

    Enum.intersperse(pair, Enum.at(pairs_to_add, 0, []))
    |> List.flatten()
  end

  defp extend_pair(pair, field), do: pair
end

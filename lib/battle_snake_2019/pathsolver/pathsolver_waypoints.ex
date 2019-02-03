defmodule BattleSnake2019.Pathsolver.Waypoints do
  import BattleSnake2019.Field
  import BattleSnake2019.Field.Nodes

  def get_waypoint_direction(node, start) do
    key = if start["x"] == node["x"], do: "y", else: "x"
    difference = start[key] - node[key]
    directions(key, difference)
  end

  def collect_waypoints_to_goal(start, [current_waypoint | rest], closed_list, field) do
    case is_the_node?(start, current_waypoint) do
      true ->
        [true, closed_list, start: current_waypoint]

      false ->
        updated_closed_list = closed_list ++ [current_waypoint]

        adjacent_nodes =
          get_adjacent_nodes_and_cost(field, current_waypoint)
          |> Enum.filter(fn waypoint -> keep_waypoint?(waypoint, rest) end)

        updated_open_list = rest ++ adjacent_nodes
        found_start? = Enum.find(adjacent_nodes, fn waypoint -> is_the_node?(start, waypoint) end)

        if found_start?,
          do: [
            true,
            updated_closed_list,
            start: Map.put(start, :cost, current_waypoint.cost + 1)
          ],
          else: collect_waypoints_to_goal(start, updated_open_list, updated_closed_list, field)
    end
  end

  # If we got to this point, we couldn't find the start!! NEW PLAN!!
  # GO HAMILTONIAN
  def collect_waypoints_to_goal(_start, [], closed_list, _field), do: [false, closed_list]

  def find_best_waypoint([waypoint | waypoints], start) do
    if waypoint.cost >= start.cost,
      do: find_best_waypoint(waypoints, start),
      else: get_waypoint_direction(waypoint, start)
  end

  defp directions("y", velocity) do
    if velocity == 1, do: "down", else: "up"
  end

  defp directions("x", velocity) do
    if velocity == 1, do: "left", else: "right"
  end

  def keep_waypoint?(
        %{segment_type: segment_type} = waypoint,
        closed_list
      ) do
    waypoint_is_not_body = segment_type != :body

    did_not_find_better_waypoint = !there_a_better_waypoint?(waypoint, closed_list)

    waypoint_is_not_body and did_not_find_better_waypoint
  end

  def keep_waypoint?(nil, _closed_list), do: false

  def keep_waypoint?(waypoint, closed_list), do: !there_a_better_waypoint?(waypoint, closed_list)

  defp there_a_better_waypoint?(%{"x" => x, "y" => y, :cost => cost}, closed_list) do
    Enum.any?(closed_list, fn closed_tile ->
      has_same_coordinate = closed_tile["x"] == x or closed_tile["y"] == y
      has_same_cost_or_better = closed_tile.cost <= cost
      has_same_cost_or_better and has_same_coordinate
    end)
  end
end

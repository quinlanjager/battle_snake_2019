defmodule BattleSnake2019.Pathsolver.Waypoints do
  alias BattleSnake2019.Field.Nodes

  def get_waypoint_direction(nil, start) do
    nil
  end

  def get_waypoint_direction(node, start) do
    key = if start["x"] == node["x"], do: "y", else: "x"
    difference = start[key] - node[key]
    directions(key, difference)
  end

  def find_best_waypoint([waypoint | waypoints], start) do
    if waypoint.cost >= start.cost,
      do: find_best_waypoint(waypoints, start),
      else: get_waypoint_direction(waypoint, start)
  end

  def get_cost(waypoint, current_node, goal) do
    heuristic = Nodes.calculate_distance(waypoint, goal)
    heuristic + current_node.cost
  end

  def get_cost(waypoint, current_node, goal, start, field) do
    heuristic = Nodes.calculate_distance(waypoint, goal)

    omitted_entities = [Map.get(start, :entity)]

    is_adjacent_to_head =
      Nodes.is_segment_adjacent_node?(field, waypoint, :head, omitted_entities)

    raw_heuristic = heuristic + current_node.cost

    # if we're adjacent to an enemy head
    # Only go there at a last resort
    if is_adjacent_to_head do
      raw_heuristic * 999_999
    else
      raw_heuristic
    end
  end

  def keep_waypoint?(
        %{segment_type: segment_type} = waypoint,
        closed_list,
        goal
      ) do
    waypoint_is_the_goal = Nodes.is_the_node?(goal, waypoint)
    waypoint_is_not_body = segment_type != :body and segment_type != :head

    waypoint_has_not_been_visited = !waypoint_has_been_visited?(waypoint, closed_list)

    (waypoint_is_not_body and waypoint_has_not_been_visited) or waypoint_is_the_goal
  end

  def keep_waypoint?(nil, _closed_list, _goal), do: false

  def keep_waypoint?(waypoint, closed_list, _goal),
    do: !waypoint_has_been_visited?(waypoint, closed_list)

  def keep_waypoint?(%{segment_type: segment_type}),
    do: segment_type != :body and segment_type != :tail and segment_type != :head

  def keep_waypoint?(nil), do: false

  def keep_waypoint?(_), do: true

  defp directions("y", velocity) do
    if velocity == -1, do: "down", else: "up"
  end

  defp directions("x", velocity) do
    if velocity == -1, do: "right", else: "left"
  end

  defp waypoint_has_been_visited?(%{"x" => x, "y" => y}, closed_list) do
    Enum.any?(closed_list, fn closed_tile ->
      closed_tile["x"] == x and closed_tile["y"] == y
    end)
  end
end

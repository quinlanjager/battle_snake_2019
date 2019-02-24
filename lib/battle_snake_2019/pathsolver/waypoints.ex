defmodule BattleSnake2019.Pathsolver.Waypoints do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Field.Snake, as: FieldSnake
  alias BattleSnake2019.Snake
  alias BattleSnake2019.Snake.Body

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

  def get_cost(waypoint, current_node, goal, start, %{
        "field" => field,
        "board" => %{"snakes" => snakes},
        "you" => my_snake
      }) do
    heuristic = Nodes.calculate_distance(waypoint, goal)

    no_deadly_snake_heads =
      FieldSnake.count_deadly_adjacent_snake_heads(field, waypoint, snakes, my_snake["id"])

    node_safety = Nodes.calculate_node_safety(field, waypoint, [:tail, :body])
    raw_heuristic = heuristic + current_node.cost + node_safety

    # if we're adjacent to an enemy head
    # Only go there at a last resort
    if no_deadly_snake_heads > 0 do
      raw_heuristic * 999_999
    else
      raw_heuristic
    end
  end

  def keep_waypoint?(%{segment_type: :body} = waypoint, _closed_list, goal),
    do: Nodes.is_the_node?(goal, waypoint) or false

  def keep_waypoint?(%{segment_type: :head} = waypoint, _closed_list, goal),
    do: Nodes.is_the_node?(goal, waypoint) or false

  def keep_waypoint?(nil, _closed_list, _goal), do: false

  def keep_waypoint?(waypoint, closed_list, _goal),
    do: !waypoint_has_been_visited?(waypoint, closed_list)

  def keep_emergency_waypoint?(%{segment_type: :body}, _game), do: false

  def keep_emergency_waypoint?(%{segment_type: :head, entity: id} = node, %{
        "board" => %{"snakes" => snakes},
        "you" => my_snake
      }) do
    enemy_snake = Snake.get_snake(snakes, id)
    Body.is_larger_than_snake?(my_snake, enemy_snake)
  end

  def keep_emergency_waypoint?(nil, _game), do: false

  def keep_emergency_waypoint?(waypoint, %{
        "field" => field,
        "board" => %{"snakes" => snakes},
        "you" => my_snake
      }),
      do:
        FieldSnake.count_larger_adjacent_snake_heads(field, waypoint, snakes, my_snake["id"]) == 0

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

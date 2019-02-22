defmodule BattleSnake2019.Snake.Body do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Pathsolver.Waypoints

  def find_enemy_snakes(snake, snakes) do
    Enum.filter(snakes, fn other_snake ->
      Map.get(other_snake, "id") != Map.get(snake, "id")
    end)
    |> Enum.map(fn other_snake ->
      snake_head = Enum.at(snake["body"], 0)
      body = Map.get(other_snake, "body")
      body_size = length(body)
      head = Enum.at(body, 0)
      head_distance = Nodes.calculate_distance(snake_head, head)
      head_is_adjacent = Nodes.is_adjacent_node?(head, snake_head)
      {head, head_distance, body_size, head_is_adjacent}
    end)
    |> Enum.sort_by(
      fn {_head, head_distance, _body_size, _head_is_adjacent} ->
        head_distance
      end,
      &<=/2
    )
  end

  def get_body_size(%{"body" => body}) do
    length(body)
  end

  def get_body_size(_), do: 0

  def get_false_tail(%{"id" => id, "body" => body}, field) do
    last_segment = List.last(body)
    omitted_types = [:body, :head, :tail]

    adjacent_nodes =
      Nodes.get_adjacent_nodes(field, last_segment)
      |> Enum.filter(&Waypoints.keep_waypoint?/1)
      |> Enum.map(fn node ->
        {node, Nodes.calculate_node_safety(field, node, omitted_types)}
      end)
      |> Enum.sort_by(fn {_node, safety} -> safety end, &<=/2)

    {tail, _} = Enum.at(adjacent_nodes, 0, {nil, 0})
    Map.put(tail, :segment_type, :tail) |> Map.put(:entity, id)
  end
end

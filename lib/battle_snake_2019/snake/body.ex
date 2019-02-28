defmodule BattleSnake2019.Snake.Body do
  alias BattleSnake2019.Field.Snake, as: FieldSnake
  alias BattleSnake2019.Snake
  alias BattleSnake2019.Field.Nodes

  def find_enemy_snakes(field, snake, snakes) do
    Enum.filter(snakes, fn other_snake ->
      Map.get(other_snake, "id") != Map.get(snake, "id")
    end)
    |> Enum.map(fn other_snake ->
      snake_head = Enum.at(snake["body"], 0)
      body = Map.get(other_snake, "body")
      body_size = length(body)
      head = FieldSnake.get_segment_location(field, other_snake["id"], :head)
      head_distance = Nodes.calculate_distance(snake_head, head)
      head_is_adjacent = Nodes.is_adjacent_node?(head, snake_head)
      {head, head_distance, body_size, head_is_adjacent}
    end)
  end

  def get_body_size(%{"body" => body}) do
    length(body)
  end

  def get_body_size(_), do: 0

  def get_false_tail(%{"id" => id, "body" => body}, %{"field" => field} = game) do
    last_segment = List.last(body)
    omitted_types = [:body, :head]

    adjacent_nodes =
      Nodes.get_adjacent_nodes(field, last_segment)
      |> Enum.filter(fn
        %{segment_type: :body} -> false
        %{segment_type: :tail} -> false
        nil -> false
        _ -> true
      end)
      |> Enum.map(fn node ->
        {node, Nodes.calculate_node_safety(field, node, omitted_types)}
      end)
      |> Enum.sort_by(fn {_node, safety} -> safety end, &<=/2)

    {tail, _} = Enum.at(adjacent_nodes, 0, {nil, 0})
    Map.put(tail, :segment_type, :tail) |> Map.put(:entity, id)
  end

  def is_larger_than_snake?(snake, other_snake) do
    get_body_size(snake) > get_body_size(other_snake)
  end
end

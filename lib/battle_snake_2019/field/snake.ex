defmodule BattleSnake2019.Field.Snake do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Snake.Body

  defstruct entity: nil, segment_type: nil
  @segment_types [:head, :body, :tail]

  #  process snakes
  def process_snakes(field, snake_head, [%{"body" => body, "id" => id} | rest]) do
    last_snake_index = length(body) - 1

    unique_nodes =
      Enum.with_index(body)
      |> Enum.map(fn
        {node, 0} ->
          {node, :head}

        {node, index} ->
          if index == last_snake_index, do: {node, :tail}, else: {node, :body}
      end)
      |> Enum.uniq_by(fn {%{"x" => x, "y" => y}, _segment} -> "#{x}_#{y}" end)

    process_snake_body(field, snake_head, unique_nodes, id)
    |> process_snakes(snake_head, rest)
  end

  def process_snakes(field, snake_head, []) do
    field
  end

  def process_snake_body(field, snake_head, [], _id) do
    field
  end

  def process_snake_body(field, snake_head, [{segment_coords, segment} | []], id) do
    Nodes.update_node(field, snake_head, segment_coords, id, segment)
    |> process_snake_body(snake_head, [], id)
  end

  def process_snake_body(field, snake_head, [{segment_coords, segment} | rest], id) do
    Nodes.update_node(field, snake_head, segment_coords, id, segment)
    |> process_snake_body(snake_head, rest, id)
  end

  def get_segment_types do
    @segment_types
  end

  def get_segment_location(field, snake_id, segment) do
    Enum.find(field, fn node ->
      entity = Map.get(node, :entity)
      segment_type = Map.get(node, :segment_type)
      entity == snake_id and segment_type == segment
    end)
  end

  def get_adjacent_snake_heads(field, node, snakes, omitted_snake_id \\ nil) do
    Enum.map(snakes, fn %{"id" => id} -> get_segment_location(field, id, :head) end)
    |> Enum.filter(fn snake_head ->
      Nodes.is_adjacent_node?(node, snake_head) and snake_head.entity != omitted_snake_id
    end)
  end

  def count_deadly_adjacent_snake_heads(field, node, snakes, omitted_snake_id \\ nil) do
    adjacent_snake_heads = get_adjacent_snake_heads(field, node, snakes, omitted_snake_id)

    Enum.count(adjacent_snake_heads, fn %{entity: snake_id} ->
      enemy_snake_size =
        Enum.find(snakes, fn %{"id" => id} -> id == snake_id end)
        |> Body.get_body_size()

      my_snake_size =
        Enum.find(snakes, fn %{"id" => id} -> id == omitted_snake_id end)
        |> Body.get_body_size()

      enemy_snake_size >= my_snake_size
    end)
  end
end

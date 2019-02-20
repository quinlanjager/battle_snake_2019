defmodule BattleSnake2019.Field.Snake do
  alias BattleSnake2019.Field.Nodes

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
end

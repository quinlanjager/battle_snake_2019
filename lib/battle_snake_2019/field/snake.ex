defmodule BattleSnake2019.Field.Snake do
  import BattleSnake2019.Field.Nodes

  defstruct entity: nil, segment_type: nil
  @segment_types [:head, :body, :tail]

  #  process snakes
  def process_snakes(field, snake_head, [%{"body" => body, "id" => id} | rest]) do
    unique_nodes = Enum.uniq_by(body, fn %{"x" => x, "y" => y} -> "#{x}_#{y}" end)

    process_snake_body(field, snake_head, unique_nodes, id, :head)
    |> process_snakes(snake_head, rest)
  end

  def process_snakes(field, snake_head, []) do
    field
  end

  def process_snake_body(field, snake_head, [], _id) do
    field
  end

  def process_snake_body(field, snake_head, [segment_coords | []], id) do
    update_node(field, snake_head, segment_coords, id, :tail)
    |> process_snake_body(snake_head, [], id)
  end

  def process_snake_body(field, snake_head, [segment_coords | rest], id) do
    update_node(field, snake_head, segment_coords, id, :body)
    |> process_snake_body(snake_head, rest, id)
  end

  def process_snake_body(field, snake_head, [segment_coords | rest], id, :head) do
    update_node(field, snake_head, segment_coords, id, :head)
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

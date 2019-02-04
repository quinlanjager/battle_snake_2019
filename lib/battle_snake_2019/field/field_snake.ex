defmodule BattleSnake2019.Field.Snake do
  import BattleSnake2019.Field.Nodes

  def move_snake_on_field(field, [snake_segment | body], {coord, change}) do
    next_segment = Enum.get(body, 0)
    segment_coords = "#{snake_segment["x"]}_#{snake_segment["y"]}"

    new_snake_segment_position =
      Map.get(field, segment_coords) |> Map.put(coord, snake_segment[coord] + change)
  end

  def get_next_segment_change(next_segment, current_segment) do
    x_change = current_segment["x"] - next_segment["x"]
    y_change = current_segment["y"] - next_segment["y"]
    if x_change == 0, do: {"y", y_change}, else: {"x", x_change}
  end

  #  process snakes
  def process_snakes(field, [%{"body" => body, "id" => id} | rest]) do
    process_snake_body(field, body, id, :head)
    |> process_snakes(rest)
  end

  def process_snakes(field, []) do
    field
  end

  def process_snake_body(field, [], _id) do
    field
  end

  def process_snake_body(field, [segment_coords | []], id) do
    update_node(field, segment_coords, id, :tail)
    |> process_snake_body([], id)
  end

  def process_snake_body(field, [segment_coords | rest], id) do
    update_node(field, segment_coords, id, :body)
    |> process_snake_body(rest, id)
  end

  def process_snake_body(field, [segment_coords | rest], id, :head) do
    update_node(field, segment_coords, id, :head)
    |> process_snake_body(rest, id)
  end

  def get_segment_location(field, snake_id, segment) do
    Enum.find(field, fn node ->
      entity = Map.get(node, :entity)
      segment_type = Map.get(node, :segment_type)
      entity == snake_id and segment_type == segment
    end)
  end
end

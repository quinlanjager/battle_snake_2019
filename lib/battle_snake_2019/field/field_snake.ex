defmodule BattleSnake2019.Field.Snake do
  import BattleSnake2019.Field.Nodes
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

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
    add_node(field, segment_coords, id, :tail)
    |> process_snake_body([], id)
  end

  def process_snake_body(field, [segment_coords | rest], id) do
    add_node(field, segment_coords, id, :body)
    |> process_snake_body(rest, id)
  end

  def process_snake_body(field, [segment_coords | rest], id, :head) do
    add_node(field, segment_coords, id, :head)
    |> process_snake_body(rest, id)
  end

  def get_color do
    @color
  end

  def get_valid_moves do
    @valid_moves
  end

  # def move(%{} = game) do
  # end

  def move(_) do
    %{"move" => "right"}
  end

  def get_snake_name do
    @name
  end

  def get_segment_location(field, snake_id, segment) do
    field_coords = Map.values(field)

    Enum.find(field_coords, fn node ->
      entity = Map.get(node, :entity)
      segment_type = Map.get(node, :segment_type)
      entity == snake_id and segment_type == segment
    end)
  end
end

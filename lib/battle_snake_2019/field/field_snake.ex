defmodule BattleSnake2019.Field.Snake do
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

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

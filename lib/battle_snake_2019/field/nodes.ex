defmodule BattleSnake2019.Field.Nodes do
  import Kernel
  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def is_the_node?(node, other) do
    Map.get(node, "x") == Map.get(other, "x") and Map.get(node, "y") == Map.get(other, "y")
  end

  def is_same_node_type?(node, other) do
    is_same_entity?(node, other) and is_same_segment?(node, other)
  end

  def is_same_entity?(node, other) do
    Map.get(node, :entity) == Map.get(other, :entity)
  end

  def is_same_segment?(node, other) do
    Map.get(node, :segment_type) == Map.get(other, :segment_type)
  end

  def is_adjacent_node?(node, other) do
    %{"x" => x_difference, "y" => y_diffrence} = get_distance(node, other)
    is_adjacent_vertically = x_difference == 1 and other["y"] == node["y"]
    is_adjacent_horizontally = y_diffrence == 1 and other["x"] == node["x"]

    is_adjacent_horizontally or is_adjacent_vertically
  end

  def calculate_distance(node, other) do
    %{"x" => x_difference, "y" => y_diffrence} = get_distance(node, other)
    :math.sqrt(:math.pow(x_difference, 2) + :math.pow(y_diffrence, 2))
  end

  def get_adjacent_nodes(field, node) do
    Task.async_stream(@directions, fn direction ->
      [coordinate, directions] = direction

      Enum.map(directions, fn dir ->
        adjacent_node_coords = Map.put(node, coordinate, node[coordinate] + dir)
        get_node(field, adjacent_node_coords)
      end)
    end)
    |> Enum.reduce([], fn {:ok, result}, soFar -> soFar ++ result end)
    |> List.flatten()
  end

  def get_adjacent_node(field, node, direction) do
    {coordinate, adjustment} = get_adjustment_by_direction(direction)
    current_cordinate = node[coordinate]
    node_to_find = Map.put(node, coordinate, current_cordinate + adjustment)
    get_node(field, node_to_find)
  end

  def get_node(field, node) do
    Enum.find(field, fn field_node -> is_the_node?(node, field_node) end)
  end

  # add things to field
  def update_node(field, %{"x" => x, "y" => y}, entity, segment_type \\ nil) do
    node_index = Enum.find_index(field, fn node -> node["x"] == x and node["y"] == y end)

    updated_node =
      Enum.at(field, node_index)
      |> Map.merge(%{
        entity: entity,
        segment_type: segment_type
      })

    List.replace_at(field, node_index, updated_node)
  end

  defp get_distance(node, other) do
    node_y = Map.get(node, "y")
    node_x = Map.get(node, "x")
    other_y = Map.get(other, "y")
    other_x = Map.get(other, "x")
    x_difference = node_x - other_x
    y_diffrence = node_y - other_y

    %{"x" => max(x_difference, x_difference * -1), "y" => max(y_diffrence, y_diffrence * -1)}
  end

  defp get_adjustment_by_direction(direction) do
    case direction do
      "left" ->
        {"x", -1}

      "right" ->
        {"x", +1}

      "up" ->
        {"y", -1}

      "down" ->
        {"y", +1}
    end
  end
end

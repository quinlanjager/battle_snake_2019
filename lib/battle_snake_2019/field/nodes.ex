defmodule BattleSnake2019.Field.Nodes do
  import Kernel

  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def is_node_segment?(%{segment_type: segment_type}, maybe_segment) do
    segment_type == maybe_segment
  end

  def is_node_segment?(_node, _maybe_segment), do: false

  def is_node_entity?(%{entity: entity}, maybe_entity) do
    entity == maybe_entity
  end

  def is_node_entity?(_node, _maybe_entity), do: false

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

  def is_node_adjacent_to_wall?(field, node) do
    adjacent_nodes = get_adjacent_nodes(field, node)
    Enum.any?(adjacent_nodes, fn node -> is_nil(node) end)
  end

  def calculate_node_safety(field, node, off_limit_segments \\ []) do
    adjacent_nodes = get_adjacent_nodes(field, node)

    Enum.count(adjacent_nodes, fn adjacent_node ->
      is_nil(adjacent_node) or
        Enum.any?(off_limit_segments, fn segment_type ->
          is_same_segment?(adjacent_node, %{segment_type: segment_type})
        end)
    end)
  end

  def is_adjacent_node?(node, other) do
    %{"x" => x_difference, "y" => y_diffrence} = get_distance(node, other)
    is_adjacent_vertically = x_difference == 1 and other["y"] == node["y"]
    is_adjacent_horizontally = y_diffrence == 1 and other["x"] == node["x"]

    is_adjacent_horizontally or is_adjacent_vertically
  end

  def is_segment_adjacent_node?(field, node, type, omitted_entities \\ []) do
    get_adjacent_nodes(field, node)
    |> Enum.filter(&is_map/1)
    |> Enum.any?(fn adj_node ->
      Map.get(adj_node, :segment_type) == type and
        !Enum.member?(omitted_entities, Map.get(adj_node, :entity))
    end)
  end

  def calculate_distance(node, other) do
    %{"x" => x_difference, "y" => y_difference} = get_distance(node, other)
    :math.sqrt(:math.pow(x_difference, 2) + :math.pow(y_difference, 2))
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
  def update_node(field, snake_head, %{"x" => x, "y" => y} = node, entity, segment_type \\ nil) do
    node_index = Enum.find_index(field, fn node -> node["x"] == x and node["y"] == y end)

    updated_node =
      Enum.at(field, node_index)
      |> Map.merge(%{
        entity: entity,
        segment_type: segment_type,
        dist: calculate_distance(snake_head, node)
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

defmodule BattleSnake2019.Field.Nodes do
  import Kernel
  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def is_the_node?(node, other) do
    Map.get(node, "x") == Map.get(other, "x") and Map.get(node, "y") == Map.get(other, "y")
  end

  def is_same_node_type?(node, other) do
    Map.get(node, :entity) == Map.get(other, :entity) and
      Map.get(node, :segment_type) == Map.get(other, :segment_type)
  end

  def is_adjacent_node?(node, other) do
    node_y = Map.get(node, "y")
    node_x = Map.get(node, "x")
    other_y = Map.get(other, "y")
    other_x = Map.get(other, "x")
    x_difference = node_x - other_x
    y_diffrence = node_y - other_y

    is_adjacent_vertically = max(x_difference, x_difference * -1) == 1 and other_y == node_y
    is_adjacent_horizontally = max(y_diffrence, y_diffrence * -1) == 1 and other_x == node_x

    is_adjacent_horizontally or is_adjacent_vertically
  end

  def get_adjacent_nodes(field, node) do
    Enum.map(@directions, fn direction ->
      [coordinate, directions] = direction

      Enum.map(directions, fn dir ->
        adjacent_node_coords = Map.put(node, coordinate, node[coordinate] + dir)
        adjacent_node = get_node(field, adjacent_node_coords)

        if is_nil(adjacent_node),
          do: nil,
          else: adjacent_node
      end)
    end)
    |> List.flatten()
  end

  def get_adjacent_nodes_and_cost(field, node) do
    Task.async_stream(@directions, fn direction ->
      [coordinate, directions] = direction

      Enum.map(directions, fn dir ->
        adjacent_node_coords = Map.put(node, coordinate, node[coordinate] + dir)
        adjacent_node = get_node(field, adjacent_node_coords)

        if is_nil(adjacent_node),
          do: nil,
          else: Map.merge(adjacent_node, %{cost: node.cost + 1})
      end)
    end)
    |> Enum.reduce([], fn {_code, result}, soFar -> soFar ++ result end)
    |> List.flatten()
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
end

defmodule BattleSnake2019.Field.Nodes do
  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def is_the_node?(%{"x" => x, "y" => y}, coords) do
    x == coords["x"] and y == coords["y"]
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
    |> Enum.filter(&Kernel.is_map/1)
  end

  def get_adjacent_nodes_and_cost(field, node) do
    Enum.map(@directions, fn direction ->
      [coordinate, directions] = direction

      Enum.map(directions, fn dir ->
        adjacent_node_coords = Map.put(node, coordinate, node[coordinate] + dir)
        adjacent_node = get_node(field, adjacent_node_coords)

        if is_nil(adjacent_node),
          do: nil,
          else: Map.merge(adjacent_node, %{cost: node.cost + 1})
      end)
    end)
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
defmodule BattleSnake2019.Field.Nodes do
  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def is_the_node?(%{"x" => x, "y" => y}, coords) do
    x == coords["x"] and y == coords["y"]
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
    coords = Map.values(field)
    Enum.find(coords, fn field_node -> is_the_node?(node, field_node) end)
  end

  # add things to field
  def add_node(field, %{"x" => x, "y" => y}, entity, segment_type \\ nil) do
    coordinate = "#{x}_#{y}"

    updated_tile =
      Map.fetch!(field, coordinate)
      |> Map.merge(%{
        entity: entity,
        segment_type: segment_type
      })

    Map.put(field, coordinate, updated_tile)
  end
end

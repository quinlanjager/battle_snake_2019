defmodule BattleSnake2019.Field do
  import BattleSnake2019.Field.Nodes
  @directions [["x", [1, -1]], ["y", [1, -1]]]

  def create_field(%{"board" => board} = game) do
    %{
      "height" => height,
      "width" => width
    } = board

    field =
      1..height
      |> Enum.map(fn row -> build_row(row, width) end)
      |> List.flatten()
      |> Enum.reduce(%{}, fn %{"x" => x, "y" => y} = tile, soFar ->
        Map.put(soFar, "#{x}_#{y}", tile)
      end)

    Map.put_new(game, "field", field)
  end

  def update_field(field, %{"board" => board}) do
    %{
      "snakes" => snakes,
      "food" => foods
    } = board

    process_foods(field, foods) |> process_snakes(snakes)
  end

  def find_nearest_food(field, start) do
    field_coords = Map.values(field)

    food_locations =
      Enum.filter(field_coords, fn coords ->
        Map.get(coords, :entity) == :food
      end)
      |> Enum.map(fn %{"x" => x, "y" => y} = food ->
        x_distance_from_start = x - start["x"]
        y_distance_from_start = y - start["y"]
        x_distance_from_start = Kernel.max(x_distance_from_start, x_distance_from_start * -1)
        y_distance_from_start = Kernel.max(y_distance_from_start, y_distance_from_start * -1)
        Map.put(food, :distance, x_distance_from_start + y_distance_from_start)
      end)

    number_of_locations = length(food_locations)

    if number_of_locations > 1,
      do: Enum.sort_by(food_locations, & &1.distance),
      else: food_locations
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

  defp build_row(row, width) do
    1..width
    |> Enum.map(fn column -> %{"x" => column, "y" => row} end)
  end

  #  process snakes
  defp process_snakes(field, [%{"body" => body, "id" => id} | rest]) do
    process_snake_body(field, body, id, :head)
    |> process_snakes(rest)
  end

  defp process_snakes(field, []) do
    field
  end

  defp process_snake_body(field, [], _id) do
    field
  end

  defp process_snake_body(field, [segment_coords | []], id) do
    add_entity_to_field(field, segment_coords, id, :tail)
    |> process_snake_body([], id)
  end

  defp process_snake_body(field, [segment_coords | rest], id) do
    add_entity_to_field(field, segment_coords, id, :body)
    |> process_snake_body(rest, id)
  end

  defp process_snake_body(field, [segment_coords | rest], id, :head) do
    add_entity_to_field(field, segment_coords, id, :head)
    |> process_snake_body(rest, id)
  end

  # process food
  defp process_foods(field, [food_coords | rest]) do
    add_entity_to_field(field, food_coords, :food)
    |> process_foods(rest)
  end

  defp process_foods(field, []) do
    field
  end

  # add things to field
  defp add_entity_to_field(field, %{"x" => x, "y" => y}, entity, segment_type \\ nil) do
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

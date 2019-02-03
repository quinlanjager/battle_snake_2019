defmodule BattleSnake2019.Field.Food do
  import BattleSnake2019.Field.Nodes

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

  # process food
  def process_foods(field, [food_coords | rest]) do
    add_node(field, food_coords, :food)
    |> process_foods(rest)
  end

  def process_foods(field, []) do
    field
  end
end

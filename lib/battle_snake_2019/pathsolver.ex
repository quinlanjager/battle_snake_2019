defmodule BattleSnake2019.Pathsolver do
  import BattleSnake2019.Snake

  def find_best_path_for_snake(snake_id, %{"field" => field, "you" => snake}) do
    field_coords = Map.to_list(field)

    snake_head = get_head_location(snake)

    sorted_food = find_nearest_food(snake_head, field_coords)

    snake_tail = get_tail_location(snake)

    goals = [tail: snake_tail, food: sorted_food]

    result =
      Task.async_stream(goals, fn goal -> find_shortest_path(goal, field) end)
      |> Enum.reduce([], fn {:ok, result}, soFar -> soFar ++ [result] end)

    if result.food, do: result.food, else: result.tail
  end

  def find_nearest_food(head, field_coords) do
    food_locations =
      Enum.filter(field_coords, fn %{entity: entity, segment_type: segment_type} ->
        entity == :food
      end)
      |> Enum.map(fn %{x: x, y: x} = food ->
        x_distance_from_head = x - head["x"]
        y_distance_from_head = x - head["y"]
        x_distance_from_head = Kenel.max(x_distance_from_head, x_distance_from_head * -1)
        y_distance_from_head = Kenel.max(y_distance_from_head, x_distance_from_head * -1)
        Map.put(distance: x_distance_from_head + y_distance_from_head)
      end)
      |> Eum.sort(&(&1.distance >= &2.distance))

    food_locations
  end

  defp find_shortest_path([:tail, tail], field) do
  end

  defp find_shortest_path([:food, food_coords], field) do
  end
end

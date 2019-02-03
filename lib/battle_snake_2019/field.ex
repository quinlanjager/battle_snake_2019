defmodule BattleSnake2019.Field do
  import BattleSnake2019.Field.Nodes
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Food

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

  defp build_row(row, width) do
    1..width
    |> Enum.map(fn column -> %{"x" => column, "y" => row} end)
  end
end

defmodule BattleSnake2019.Field do
  import BattleSnake2019.Field.Snake
  import BattleSnake2019.Field.Food

  def create_field(%{"board" => board}) do
    %{
      "height" => height,
      "width" => width
    } = board

    0..(height - 1)
    |> Enum.map(fn row -> build_row(row, width) end)
    |> List.flatten()
  end

  def update_field(field, %{"board" => board}) do
    %{
      "snakes" => snakes,
      "food" => foods
    } = board

    process_foods(field, foods) |> process_snakes(snakes)
  end

  defp build_row(row, width) do
    0..(width - 1)
    |> Enum.map(fn column -> %{"x" => column, "y" => row} end)
  end
end

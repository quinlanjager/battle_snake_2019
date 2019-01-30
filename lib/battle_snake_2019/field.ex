defmodule BattleSnake2019.Field do
  def create_field(%{"board" => board}) do
    %{
      "height" => height,
      "width" => width
    } = board

    field =
      1..height
      |> Enum.map(fn row -> build_row(row, width) end)

    Map.put_new(game, "field", field)
  end

  def update_field(field, %{"board" => board}) do
    %{
      "snakes" => snakes
    } = board

    sna
  end

  defp build_row(row, width) do
    1..width
    |> Enum.map(fn column -> %{} end)
  end

  defp add_entities(field, board) do
  end
end

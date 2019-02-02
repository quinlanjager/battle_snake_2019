defmodule BattleSnake2019.Nodes do
  def get_direction_to_node(start, node) do
    key = if start["x"] == node["x"], do: "y", else: "x"
    difference = start[key] - node[key]
    directions(key, difference)
  end

  def is_the_node?(%{"x" => x, "y" => y}, coords) do
    x == coords["x"] and y == coords["y"]
  end

  defp directions("y", velocity) do
    if velocity == 1, do: "down", else: "up"
  end

  defp directions("x", velocity) do
    if velocity == 1, do: "left", else: "right"
  end
end

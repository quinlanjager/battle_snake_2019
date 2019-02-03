defmodule BattleSnake2019.Field.Nodes do
  def is_the_node?(%{"x" => x, "y" => y}, coords) do
    x == coords["x"] and y == coords["y"]
  end
end

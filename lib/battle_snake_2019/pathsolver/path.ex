defmodule BattleSnake2019.Pathsolver.Path do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Pathsolver.Waypoints

  def trace_path(path, %{"x" => x, "y" => y}, path_so_far) do
    parent = Map.get(path, "#{x}_#{y}")

    if is_nil(parent) do
      path_so_far
    else
      trace_path(path, parent, [parent | path_so_far])
    end
  end
end

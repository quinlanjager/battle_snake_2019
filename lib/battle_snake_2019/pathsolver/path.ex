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

  def extend_path(path, field) do
    Enum.chunk_every(path, 2)
    |> Enum.map(fn paths ->
      extend_pair(paths, field)
    end)
    |> List.flatten()
  end

  defp extend_pair([path1, path2] = pair, field) do
    IO.inspect(path1)
    IO.inspect(path2)
    direction = Waypoints.get_waypoint_direction(path2, path1)

    directions_to_check =
      if direction == "left" or direction == "right" do
        ["up", "down"]
      else
        ["left", "right"]
      end

    pairs_to_add =
      Enum.map(directions_to_check, fn direction_to_check ->
        Enum.map(pair, fn path ->
          IO.inspect(path)
          Nodes.get_adjacent_node(field, path, direction_to_check)
        end)
      end)
      |> Enum.filter(fn [new_path_1, new_path_2] = set ->
        !Kernel.is_nil(new_path_1) and !Kernel.is_nil(new_path_2) and
          Waypoints.keep_waypoint?(new_path_1, [], %{}) and
          Waypoints.keep_waypoint?(new_path_2, [], %{})
      end)

    Enum.intersperse(pair, Enum.at(pairs_to_add, 0, []))
    |> List.flatten()
  end

  defp extend_pair(pair, field), do: pair
end

defmodule BattleSnake2019.Islands do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Pathsolver.Waypoints

  def discover(field, primary_snake_id \\ nil),
    do: gather_islands(field, [], primary_snake_id)

  def gather_islands(
        [node | rest_of_field],
        islands,
        primary_snake_id
      ) do
    if is_map(node) and Waypoints.keep_waypoint?(node) do
      new_island = build_island(rest_of_field, [node], [], primary_snake_id)

      filtered_field =
        Enum.filter(rest_of_field, fn %{id: id} ->
          !Enum.any?(new_island, fn %{id: island_node_id} -> id == island_node_id end)
        end)

      gather_islands(
        filtered_field,
        islands ++ [new_island],
        primary_snake_id
      )
    else
      gather_islands(rest_of_field, islands, primary_snake_id)
    end
  end

  def gather_islands(
        [],
        islands,
        _primary_snake_id
      ),
      do: islands

  def build_island(_field, [], new_island, _primary_snake_id), do: new_island

  def build_island(field, seed_nodes, new_island, primary_snake_id) do
    update_island = new_island ++ seed_nodes

    new_seed_nodes =
      Enum.map(seed_nodes, fn node ->
        Nodes.get_adjacent_nodes(field, node)
        |> Enum.filter(fn seed_node ->
          keep_node?(seed_node, new_island, primary_snake_id)
        end)
      end)
      |> List.flatten()
      |> Enum.uniq_by(fn %{id: id} -> id end)

    build_island(field, new_seed_nodes, update_island, primary_snake_id)
  end

  def keep_node?(nil, _new_island, _primary_snake_id), do: false

  def keep_node?(node, new_island, primary_snake_id) do
    entity = Map.get(node, :entity)
    segment = Map.get(node, :segment_type)

    its_a_good_node =
      Waypoints.keep_waypoint?(node) or (entity == primary_snake_id and segment == :head)

    !is_in_island?(new_island, node) and its_a_good_node
  end

  def is_in_island?(island, %{id: id}),
    do: Enum.any?(island, fn %{id: node_id} -> node_id == id end)
end

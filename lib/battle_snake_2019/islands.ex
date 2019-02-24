defmodule BattleSnake2019.Islands do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Snake.Body
  alias BattleSnake2019.Snake

  def discover(game),
    do: gather_islands(game, [])

  def gather_islands(
        %{
          "field" => [node | rest_of_field]
        } = game,
        islands
      ) do
    new_island = maybe_build_island(game, node, islands)

    filtered_field = filter_visited_nodes(rest_of_field, new_island)

    updated_game = Map.put(game, "field", filtered_field)

    updated_islands = if is_nil(new_island), do: islands, else: islands ++ [new_island]

    gather_islands(
      updated_game,
      updated_islands
    )
  end

  def gather_islands(
        %{
          "field" => []
        } = game,
        islands
      ),
      do: islands

  def maybe_build_island(
        %{"board" => %{"snakes" => snakes}, "you" => snake, "field" => field} = game,
        node,
        islands
      ) do
    if Enum.any?(islands, fn island -> !keep_node?(node, island, snakes, snake) end) do
      nil
    else
      build_island(game, [node], [])
    end
  end

  def build_island(_game, [], new_island), do: new_island

  def build_island(
        %{"board" => %{"snakes" => snakes}, "you" => snake, "field" => field} = game,
        seed_nodes,
        new_island
      ) do
    updated_island = new_island ++ seed_nodes

    new_seed_nodes =
      Enum.map(seed_nodes, fn node ->
        Nodes.get_adjacent_nodes(field, node)
        |> Enum.filter(fn seed_node ->
          keep_node?(seed_node, updated_island, snakes, snake)
        end)
      end)
      |> List.flatten()
      |> Enum.uniq_by(fn %{id: id} -> id end)

    build_island(game, new_seed_nodes, updated_island)
  end

  def filter_visited_nodes(rest_of_field, nil), do: rest_of_field

  def filter_visited_nodes(rest_of_field, new_island) do
    Enum.filter(rest_of_field, fn node ->
      !is_in_island?(new_island, node)
    end)
  end

  def keep_node?(nil, _new_island, _snakes, _snake), do: false

  def keep_node?(%{entity: entity, segment_type: :head} = node, new_island, snakes, snake) do
    primary_snake_id = snake["id"]
    is_not_in_island = !is_in_island?(new_island, node)

    if Nodes.is_node_entity?(node, primary_snake_id) do
      is_not_in_island
    else
      enemy_snake = Snake.get_snake(snakes, entity)
      is_not_in_island and Body.is_larger_than_snake?(snake, enemy_snake)
    end
  end

  def keep_node?(%{segment_type: :body}, _new_island, _snakes, _snake), do: false

  def keep_node?(node, new_island, _snakes, _snake) do
    !is_in_island?(new_island, node)
  end

  def is_in_island?(island, %{id: id}),
    do:
      Enum.any?(island, fn
        %{id: node_id} ->
          node_id == id
      end)

  def is_in_islands?(islands, []), do: false

  def is_in_islands?(islands, node),
    do:
      Enum.any?(islands, fn island ->
        is_in_island?(island, node)
      end)

  def is_in_same_island?(islands, node, other_node) do
    Enum.any?(islands, fn island ->
      is_in_island?(island, node) and is_in_island?(island, other_node)
    end)
  end
end

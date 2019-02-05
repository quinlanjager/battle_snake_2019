defmodule BattleSnake2019.GameServer do
  import BattleSnake2019.Field
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(name: name) do
    Agent.start_link(fn -> %{} end, name: name)
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Update a value by key. Overwrites value completely.
  """
  def put(games, game) do
    game_id = game["game"]["id"]
    field = create_field(game) |> update_field(game)
    game_with_field = Map.put(game, "field", field)

    Agent.update(games, &Map.put(&1, game_id, game_with_field))
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(games, game_id) do
    Agent.get(games, &Map.get(&1, game_id))
  end

  @doc """
  Deletes games from state
  """
  def delete(games, game_id) do
    Agent.update(games, &Map.delete(&1, game_id))
  end
end

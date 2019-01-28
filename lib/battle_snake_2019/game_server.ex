defmodule BattleSnake2019.GameServer do
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
  Gets a value from the `bucket` by `key`.
  """
  def get(games, key) do
    Agent.get(games, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(games, key, value) do
    Agent.update(games, &Map.put(&1, key, value))
  end

  @doc """
  Deletes games from state
  """
  def delete(games, key) do
    Agent.update(games, &Map.delete(&1, key))
  end
end

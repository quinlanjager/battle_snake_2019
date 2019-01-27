defmodule BattleSnake2019.GameServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, games} = BattleSnake2019.GameServer.start_link([])
    %{games: games}
  end

  test "stores values by key", %{games: games} do
    assert BattleSnake2019.GameServer.get(games, "1234") == nil

    BattleSnake2019.GameServer.put(games, "1234", %{"id" => "1234"})
    assert BattleSnake2019.GameServer.get(games, "1234")["id"] == "1234"
  end
end

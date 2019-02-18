defmodule BattleSnake2019.Rules.GoalPolicyTest do
  use ExUnit.Case
  alias BattleSnake2019.Rules.Judge
  alias BattleSnake2019.Rules.GoalPolicy

  test "evaluates to the food goal spec!" do
    facts = %{health: 1}
    result = Judge.evaluate(facts, GoalPolicy)
    assert result == [tail: 1, all_food: 0, safe_food: 0, enemy_head: 0]
  end
end

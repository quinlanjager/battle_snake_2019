defmodule BattleSnake2019.Rules.GoalMatcherTest do
  use ExUnit.Case
  alias BattleSnake2019.Rules.Judge
  alias BattleSnake2019.Rules.GoalMatcher

  test "evaluates to the food goal spec!" do
    facts = %{health: 1}
    result = Judge.evaluate(facts, GoalMatcher)
    assert result == {:all_food, :short}
  end
end

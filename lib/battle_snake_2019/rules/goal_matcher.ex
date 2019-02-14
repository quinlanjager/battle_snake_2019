defmodule BattleSnake2019.Rules.GoalMatcher do
  use BattleSnake2019.Rules.Rule

  rule "when health is too low, get any food" do
    when_value("health", &Kernel.<=/2, 60)
    %{entity: :food, segment_type: nil}
  end
end

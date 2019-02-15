defmodule BattleSnake2019.Rules.GoalMatcher do
  use BattleSnake2019.Rules.Rule

  rule "when health is a little low, get safe food" do
    when_value(:health, &<=/2, 60)
    when_value(:safe_food_length, &>=/2, 0)
    :safe_food
  end

  rule "when health is too low, get any food" do
    when_value(:health, &<=/2, 40)
    when_value(:all_food_length, &>=/2, 0)
    :all_food
  end

  rule "when the body is small, eat" do
    when_value(:body_size, &<=/2, 5)
    when_value(:safe_food_length, &>=/2, 0)
    :safe_food
  end

  rule "when the body is small, but there is not safe food eat anything" do
    when_value(:body_size, &<=/2, 5)
    when_value(:safe_food_length, &==/2, 0)
    :all_food
  end

  rule "chase tail" do
    :tail
  end
end

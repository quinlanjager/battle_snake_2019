defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :safe_food do
    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :subtract)
    weight_by(:safe_food_length, :add)
    weight_by(:nearest_safe_food_dist, :subtract)
  end

  policy :all_food do
    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :subtract)
    weight_by(:all_food_length, :add)
    weight_by(:nearest_food_dist, :subtract, 3)
  end

  policy :tail do
    weight(:add)
  end
end

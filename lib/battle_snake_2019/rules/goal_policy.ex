defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :enemy_head do
    weight_by(:enemy_head_distance, :subtract, 12)
    weight_by(:enemy_body_difference, :add, 15)
    weight_by(:enemy_head_is_adjacent, :subtract, 999_999)
  end

  policy :safe_food do
    weight_by(:body_size, :subtract, 1.25)
    weight_by(:health_lost, :add, 1.5)
    weight_by(:safe_food_length, :add, 0.5)
    weight_by(:nearest_safe_food_dist, :subtract, 0.5)
  end

  policy :all_food do
    weight_by(:body_size, :subtract, 2)
    weight_by(:health_lost, :add, 1.75)
    weight_by(:all_food_length, :add, 0.15)
    weight_by(:nearest_food_dist, :subtract)
  end

  policy :tail do
    weight_by(:enemy_body_difference, :subtract, 3)
    # TODO add an "omit" clause
    weight_by(:tail_is_hidden, :subtract, 15)
    weight_by(:snake_safety, :add)
    weight(:add)
  end
end

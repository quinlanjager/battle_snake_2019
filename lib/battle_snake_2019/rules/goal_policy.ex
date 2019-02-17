defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :enemy_head do
    weight_by(:enemy_head_distance, :subtract, 5)
    weight_by(:enemy_body_difference, :add, 15)
  end

  policy :safe_food do
    weight_by(:body_size, :subtract, 6)
    weight_by(:health_lost, :subtract, 0.25)
    weight_by(:safe_food_length, :add, 10)
    weight_by(:nearest_safe_food_dist, :subtract, 1)
  end

  policy :all_food do
    weight_by(:body_size, :subtract, 6)
    weight_by(:health_lost, :subtract, 1)
    weight_by(:all_food_length, :add, 2)
    weight_by(:nearest_food_dist, :subtract, 1)
  end

  policy :tail do
    # TODO add nearest enemy snake
    weight_by(:enemy_head_distance, :add)
    weight_by(:enemy_body_difference, :subtract, 5)
    weight_by(:tail_is_hidden, :subtract, 200)
    weight_by(:tail_safety, :subtract, 10)
    weight(:add)
  end
end

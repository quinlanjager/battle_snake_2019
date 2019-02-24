defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :enemy_head do
    weight_by(:enemy_head_distance, :subtract, 5)
    weight_by(:enemy_body_difference, :add, 10)
    weight_by(:enemy_head_is_adjacent, :subtract, 999_999)
  end

  policy :safe_food do
    weight_by(:no_safe_food, :subtract, 999_999)

    weight_by(:largest_body_difference, :subtract, 5)
    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :add)
    weight_by(:safe_food_length, :add, 1.25)
    weight_by(:nearest_safe_food_dist, :subtract)
  end

  policy :all_food do
    weight_by(:no_ok_food, :subtract, 999_999)

    weight_by(:largest_body_difference, :subtract, 5)
    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :add)
    weight_by(:all_food_length, :add)
    weight_by(:nearest_food_dist, :subtract)
  end

  policy :tail do
    weight_by(:no_tail, :subtract, 999_999)
    weight_by(:no_ok_food, :add, 20)
    weight_by(:no_of_enemy_nearby, :add)
    weight_by(:nearest_food_dist, :add, 0.1)
    weight_by(:nearest_safe_food_dist, :add, 0.1)
    weight_by(:snake_safety, :add)
  end
end

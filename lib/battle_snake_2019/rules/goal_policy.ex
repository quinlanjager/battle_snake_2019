defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :enemy_head do
    weight_by(:enemy_head_distance, :subtract, 5)
    weight_by(:enemy_body_difference, :add, 12)
    weight_by(:enemy_head_is_adjacent, :subtract, 999_999)
  end

  policy :safe_food do
    weight_by(:no_safe_food, :subtract, 999_999)

    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :add)
    weight_by(:safe_food_length, :add, 5.25)
  end

  policy :all_food do
    weight_by(:no_ok_food, :subtract, 999_999)

    weight_by(:body_size, :subtract)
    weight_by(:health_lost, :add)
    weight_by(:all_food_length, :add, 5)
  end

  policy :tail do
    weight_by(:no_tail, :subtract, 999_999)
    weight_by(:no_of_enemy_nearby, :add, 10)
    weight(:add)
  end
end

defmodule BattleSnake2019.Rules.GoalPolicy do
  use BattleSnake2019.Rules.Policy

  policy :enemy_head do
    weight_by(:enemy_head_distance, :subtract, 2)
    weight_by(:enemy_body_difference, :add, 20)
    weight_by(:enemy_head_is_adjacent, :subtract, 999_999)
  end

  policy :safe_food do
    weight_by(:no_safe_food, :subtract, 999_999)

    weight_by(:largest_body_difference, :add, 5)
    weight_by(:health_lost, :add)
    weight_by(:safe_food_length, :add, 5.25)
  end

  policy :all_food do
    weight_by(:no_ok_food, :subtract, 999_999)

    weight_by(:largest_body_difference, :add, 5)
    weight_by(:health_lost, :add)
    weight_by(:all_food_length, :add, 5)
  end

  policy :tail do
    weight_by(:no_tail, :subtract, 999_999)
    # if the enemy nearby is bigger, go for tail
    weight_by(:enemy_body_difference, :subtract, 40)
    weight(:add)
  end
end

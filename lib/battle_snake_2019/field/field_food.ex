defmodule BattleSnake2019.Field.Food do
  import BattleSnake2019.Field.Nodes

  # process food
  def process_foods(field, [food_coords | rest]) do
    update_node(field, food_coords, :food)
    |> process_foods(rest)
  end

  def process_foods(field, []) do
    field
  end
end

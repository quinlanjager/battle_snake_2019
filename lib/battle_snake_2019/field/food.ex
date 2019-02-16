defmodule BattleSnake2019.Field.Food do
  defstruct entity: :food, segment_type: nil
  alias BattleSnake2019.Field.Nodes

  # process food
  def process_foods(field, snake_head, [food_coords | rest]) do
    Nodes.update_node(field, snake_head, food_coords, :food)
    |> process_foods(snake_head, rest)
  end

  def process_foods(field, _snake_head, []) do
    field
  end

  def get_nodes(field) do
    Enum.filter(field, fn field_node ->
      Nodes.is_same_node_type?(%BattleSnake2019.Field.Food{}, field_node)
    end)
  end
end

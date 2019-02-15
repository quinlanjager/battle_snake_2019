defmodule BattleSnake2019.Field.Food do
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Field.Snake

  defstruct entity: :food, segment_type: nil

  # process food
  def process_foods(field, [food_coords | rest]) do
    Nodes.update_node(field, food_coords, :food)
    |> process_foods(rest)
  end

  def process_foods(field, []) do
    field
  end

  def get_nodes(field) do
    Enum.filter(field, fn field_node ->
      Nodes.is_same_node_type?(%BattleSnake2019.Field.Food{}, field_node)
    end)
  end

  def get_safe_nodes(field) do
    Enum.filter(field, fn field_node ->
      is_food = Nodes.is_same_node_type?(%BattleSnake2019.Field.Food{}, field_node)

      if is_food do
        adjacent_nodes = Nodes.get_adjacent_nodes(field, field_node)
        segment_types = Snake.get_segment_types()

        Enum.any?(adjacent_nodes, fn adjacent_node ->
          !is_nil(adjacent_node) and
            Enum.all?(segment_types, fn segment_type ->
              !Nodes.is_same_segment?(adjacent_node, %Snake{segment_type: segment_type})
            end)
        end)
      else
        false
      end
    end)
  end
end

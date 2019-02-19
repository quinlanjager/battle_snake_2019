defmodule BattleSnake2019.Snake.Body do
  alias BattleSnake2019.Field.Nodes

  def find_enemy_snakes(snake, snakes) do
    Enum.filter(snakes, fn other_snake ->
      Map.get(other_snake, "id") != Map.get(snake, "id")
    end)
    |> Enum.map(fn other_snake ->
      snake_head = Enum.at(snake["body"], 0)
      body = Map.get(other_snake, "body")
      body_size = length(body)
      head = Enum.at(body, 0)
      head_distance = Nodes.calculate_distance(snake_head, head)
      head_is_adjacent = Nodes.is_adjacent_node?(head, snake_head)
      {head, head_distance, body_size, head_is_adjacent}
    end)
    |> Enum.sort_by(
      fn {_head, head_distance, _body_size, _head_is_adjacent} ->
        head_distance
      end,
      &<=/2
    )
  end

  def get_body_size(%{"body" => body}) do
    length(body)
  end
end

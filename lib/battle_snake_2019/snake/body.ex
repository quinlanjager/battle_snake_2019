defmodule BattleSnake2019.Snake.Body do
  def find_enemy_snakes(snake, snakes) do
    Enum.filter(snakes, fn other_snake ->
      Map.get(other_snake, "id") != Map.get(good_snake, "id")
    end)
    |> Enum.map(fn other_snake ->
      body = Map.get(other_snake, "body")
      body_size = length(body)
      head = Enum.at(body, 0)
      head_distance = Nodes.calculate_distance(snake_head, head)
      {head, head_distance, body_size}
    end)
    |> Enum.sort_by(
      fn {_head, head_distance, _body_size} ->
        head_distance
      end,
      &<=/2
    )
  end

  def get_body_size(%{"body" => body}) do
    length(body)
  end
end

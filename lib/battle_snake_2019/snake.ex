defmodule BattleSnake2019.Snake do
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

  def get_color do
    @color
  end

  def get_valid_moves do
    @valid_moves
  end

  # def move(%{} = game) do
  # end

  def move(_) do
    %{"move" => "right"}
  end

  def get_snake_name do
    @name
  end

  def get_head_location(%{"body" => body}) do
    Enum.at(body, 0)
  end

  def get_tail_location(%{"body" => body}) do
    List.last(body)
  end
end

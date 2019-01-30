defmodule BattleSnake2019.Snake do
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]

  def get_color do
    @color
  end

  def get_valid_moves do
    @valid_moves
  end

  def move(%{} = game) do
  end

  def move(_) do
    %{"move" => "right"}
  end
end

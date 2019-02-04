defmodule BattleSnake2019.Snake do
  import BattleSnake2019.GameServer
  import BattleSnake2019.Pathsolver
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

  def move(%{"game" => %{"id" => game_id}}) do
    current_game = get(:game_server, game_id)
    move = find_best_path_for_snake(current_game)
    %{"move" => move}
  end

  def get_color do
    @color
  end

  def get_valid_moves do
    @valid_moves
  end

  def get_snake_name do
    @name
  end
end

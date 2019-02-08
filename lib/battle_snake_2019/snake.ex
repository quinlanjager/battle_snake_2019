defmodule BattleSnake2019.Snake do
  import BattleSnake2019.GameServer
  import BattleSnake2019.Pathsolver
  alias BattleSnake2019.Field.Food
  # your Snake settings
  @color "f707cb"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

  def move(%{"game" => %{"id" => game_id}}) do
    current_game = get(:game_server, game_id)
    goal_spec = %{:entity => :food, :segment_type => nil}
    move = find_path_to_goal(current_game["field"], current_game["you"], goal_spec)
    IO.puts("move #{move}")
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

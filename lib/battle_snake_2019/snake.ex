defmodule BattleSnake2019.Snake do
  alias BattleSnake2019.GameServer
  alias BattleSnake2019.Pathsolver
  alias BattleSnake2019.Facts
  alias BattleSnake2019.Rules.Judge
  alias BattleSnake2019.Rules.GoalPolicy

  # your Snake settings
  @color "#d6e100"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

  def move(%{"game" => %{"id" => game_id}}) do
    current_game = GameServer.get(:game_server, game_id)
    game_facts = Facts.get_facts(current_game)

    {goal_name, _weight} =
      Judge.evaluate(game_facts, GoalPolicy)
      |> Enum.sort_by(fn {_key, weight} -> weight end, &>=/2)
      |> Enum.at(0)

    IO.puts(goal_name)

    goals = Map.get(game_facts, goal_name)

    move =
      Pathsolver.solve_shortest_path_to_goal(current_game["field"], current_game["you"], goals)

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

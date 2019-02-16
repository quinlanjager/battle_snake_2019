defmodule BattleSnake2019.Snake do
  alias BattleSnake2019.GameServer
  alias BattleSnake2019.Pathsolver
  alias BattleSnake2019.Facts
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Rules.Judge
  alias BattleSnake2019.Rules.GoalPolicy

  # your Snake settings
  @color "#d6e100"
  @valid_moves ["right", "left", "up", "down"]
  @name "Sweetpea"

  def move(%{"game" => %{"id" => game_id}, "you" => snake, "field" => field} = current_game) do
    game_facts = Facts.get_facts(current_game)

    {goal_name, _weight} =
      Judge.evaluate(game_facts, GoalPolicy)
      |> Enum.sort_by(fn {_key, weight} -> weight end, &>=/2)
      |> Enum.at(0)

    {goals, path_type} = Map.get(game_facts, goal_name)

    move =
      if path_type == :short do
        Pathsolver.solve_shortest_path_to_goal(current_game["field"], current_game["you"], goals)
      else
        Pathsolver.solve_longest_path_to_goal(current_game["field"], current_game["you"], goals)
      end

    IO.puts(goal_name)

    case move do
      nil ->
        emergency_move = Pathsolver.emergency_move(field, snake)
        IO.puts("making an emergency move: #{emergency_move}")
        %{"move" => emergency_move}

      _ ->
        IO.puts("making valid move: #{move}")
        %{"move" => move}
    end
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

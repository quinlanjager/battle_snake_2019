defmodule BattleSnake2019.Snake do
  alias BattleSnake2019.GameServer
  alias BattleSnake2019.Pathsolver
  alias BattleSnake2019.Facts
  alias BattleSnake2019.Field.Nodes
  alias BattleSnake2019.Rules.Judge
  alias BattleSnake2019.Rules.GoalPolicy

  # your Snake settings
  @color "#d6e100"
  @head_type "bendr"
  @tail_type "bolt"
  @valid_moves ["right", "left", "up", "down"]
  @name "Jachtslang"

  def move(%{"game" => %{"id" => game_id}, "you" => snake, "field" => field} = current_game) do
    game_facts = Facts.get_facts(current_game)

    {goal_name, _weight} =
      Judge.evaluate(game_facts, GoalPolicy)
      |> Enum.sort_by(fn {_key, weight} -> weight end, &>=/2)
      |> Enum.at(0)

    {goals, _path_type} = Map.get(game_facts, goal_name)
    IO.puts(goal_name)

    move = Pathsolver.solve_shortest_path_to_goal(current_game, goals)

    case move do
      nil ->
        emergency_move = Pathsolver.emergency_move(current_game, snake)
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

  def get_head_type, do: @head_type
  def get_tail_type, do: @tail_type

  def get_snake(snakes, id) do
    Enum.find(snakes, fn %{"id" => snake_id} -> snake_id == id end)
  end
end

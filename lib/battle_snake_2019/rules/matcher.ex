defmodule BattleSnake2019.Matcher do
  use BattleSnake2019.Rules

  match "beans" do
    when_is("beans", "beans")
    "beans"
  end
end

defmodule BattleSnake2019.Rules.Policy do
  defmacro __using__(_opts) do
    quote do
      import BattleSnake2019.Rules.Policy
      @policies []

      @before_compile BattleSnake2019.Rules.Policy
    end
  end

  @doc """
  Generates a ruleset to match with facts.
  """
  defmacro policy(fact_key, do: result) do
    quote do
      var!(weight, __MODULE__) = []
      unquote(result)

      # put more specific policies first
      @policies [{unquote(fact_key), var!(weight, __MODULE__)} | @policies]
    end
  end

  @doc """
  Adds weight to the rule.
  """
  defmacro weight(change \\ :add, amount \\ 1) do
    quote do
      var!(weight, __MODULE__) = [
        {unquote(change), unquote(amount)}
        | var!(weight, __MODULE__)
      ]
    end
  end

  defmacro weight_by(key, change \\ :add, multiplier \\ 1) do
    quote do
      var!(weight, __MODULE__) = [
        {unquote(key), unquote(change), unquote(multiplier)}
        | var!(weight, __MODULE__)
      ]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_policies do
        @policies
      end

      def spy() do
        Enum.each(@policies, &IO.inspect/1)
      end
    end
  end
end

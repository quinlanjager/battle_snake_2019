defmodule BattleSnake2019.Rules do
  defmacro __using__(_opts) do
    quote do
      import BattleSnake2019.Rules
      @matchers []

      @before_compile BattleSnake2019.Rules
    end
  end

  @doc """
  Generates a ruleset to match with facts.
  """
  defmacro rule(_description \\ "", do: result)) do
    quote do
      # put give context further down
      var!(caveats, __MODULE__) = []
      result = unquote(result)
      @matchers [{var!(caveats, __MODULE__), result} | @matchers]
    end
  end

  @doc """
  Adds a caveat to the rule.
  """
  defmacro when_value(key, comparison, expectation) do
    # @TODO have the compar
    quote do
      var!(caveats, __MODULE__) = [
        {unquote(key), unquote(comparison), unquote(expectation)}
        | var!(caveats, __MODULE__)
      ]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def judge(facts) do
        Enum.find_value(@matchers, fn matcher ->
          find_match(facts, matcher)
        end)
      end

      def spy() do
        Enum.each(@matchers, &IO.inspect/1)
      end

      defp find_match(facts, {caveats, result}) do
        does_match =
          Enum.all?(caveats, fn
            {key, comparitor, expectation} ->
              value = Map.get(facts, key)
              comparitor.(value, expectation)
          end)

        if does_match, do: result, else: false
      end
    end
  end
end

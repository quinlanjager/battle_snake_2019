defmodule BattleSnake2019.Rules do
  defmacro __using__(_opts) do
    quote do
      import BattleSnake2019.Rules
      @matchers

      @before_compile BattleSnake2019.Rules
    end
  end

  defmacro match(facts, do: result) do
    quote do
      matcher = {unquote(facts)}
      # put give context further down
      var!(caveats, __MODULE__) = []
      result = unquote(result)
      @matchers [{matcher, var!(caveats, __MODULE__), result} | @matchers]
    end
  end

  defmacro when_is(comparison, expectation) do
    quote do
      var!(caveats, __MODULE__) = [
        {unquote(comparison), unquote(expectation)} | var!(caveats, __MODULE__)
      ]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def judge(facts) do
        Enum.find(@matchers, fn matcher ->
          find_match(facts, matcher)
        end)
      end

      def fire() do
        Enum.each(@matchers, &IO.inspect/1)
      end

      defp find_match(facts, {facts_to_match, {key, comparer, caveat}, result}) do
        does_match = does_match?(facts, facts_to_match)
        value = Map.get(facts, key)
        if comparer.(value, caveat), do: result, else: false
      end

      defp find_match(facts, {facts_to_match, result}) do
        if does_match?(facts, facts_to_match), do: result, else: false
      end

      defp does_match?(facts, facts_to_match) do
        filled_facts = Map.merge(facts, facts_to_match)
        Map.equal?(filled_facts, facts)
      end
    end
  end
end

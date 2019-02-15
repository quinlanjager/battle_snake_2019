defmodule BattleSnake2019.Rules.Rule do
  defmacro __using__(_opts) do
    quote do
      import BattleSnake2019.Rules.Rule
      @matchers []

      @before_compile BattleSnake2019.Rules.Rule
    end
  end

  @doc """
  Generates a ruleset to match with facts.
  """
  defmacro rule(_description, do: result) do
    quote do
      var!(caveats, __MODULE__) = []
      result = unquote(result)

      # put more specific matchers first
      @matchers [{var!(caveats, __MODULE__), result} | @matchers]
                |> Enum.sort_by(
                  fn {caveats, _result} ->
                    length(caveats)
                  end,
                  &>=/2
                )
    end
  end

  @doc """
  Adds a caveat to the rule.
  """
  defmacro when_value(key, comparison, expectation) do
    # @TODO have the comparitors come from a list
    quote do
      var!(caveats, __MODULE__) = [
        {unquote(key), unquote(comparison), unquote(expectation)}
        | var!(caveats, __MODULE__)
      ]
    end
  end

  defmacro when_value(key, comparison) do
    # @TODO have the comparitors come from a list
    quote do
      var!(caveats, __MODULE__) = [
        {unquote(key), unquote(comparison)}
        | var!(caveats, __MODULE__)
      ]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_matchers do
        @matchers
      end

      def spy() do
        Enum.each(@matchers, &IO.inspect/1)
      end
    end
  end
end

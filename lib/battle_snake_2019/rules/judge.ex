defmodule BattleSnake2019.Rules.Judge do
  def evaluate(facts, module_name) do
    matchers = Function.capture(module_name, :get_matchers, 0).()

    Enum.find_value(matchers, fn matcher ->
      find_match(facts, matcher)
    end)
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

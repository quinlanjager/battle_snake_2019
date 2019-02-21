defmodule BattleSnake2019.Rules.Judge do
  def evaluate(facts, module_name) do
    policies = Function.capture(module_name, :get_policies, 0).()

    Enum.map(policies, fn {fact_key, weights} ->
      fact_weight =
        Enum.reduce(weights, 0, fn weight, weight_so_far ->
          reduce_weight(weight, weight_so_far, facts)
        end)

      IO.inspect({fact_key, fact_weight})
      {fact_key, fact_weight}
    end)
  end

  defp reduce_weight({change, amount}, weight_so_far, _facts) do
    change_fn = Function.capture(__MODULE__, change, 2)
    change_fn.(weight_so_far, amount)
  end

  defp reduce_weight({key, change, multiplier}, weight_so_far, facts) do
    change_fn = Function.capture(__MODULE__, change, 2)
    adjustment_value = Map.get(facts, key, 0) * multiplier
    change_fn.(weight_so_far, adjustment_value)
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

  # Change functions 
  def add(a, b), do: a + b
  def subtract(a, b), do: a - b
end

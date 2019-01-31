defmodule BattleSnake2019.FieldTest do
  use ExUnit.Case
  import BattleSnake2019.Field

  test "creates a board" do
    %{"field" => field} = create_field(example_game())

    assert [
             [%{}, %{}, %{}],
             [%{}, %{}, %{}],
             [%{}, %{}, %{}]
           ] = field
  end

  test "adds items" do
    %{"field" => field} = create_field(example_game())

    assert [
             [%{}, %{}, %{}],
             [%{}, %{}, %{}],
             [%{}, %{}, %{}]
           ] = field

    updated_field = update_field(field, example_game())

    assert [
             [%{"entity" => "snake-id-string", "segment_type" => :tail}, %{}, %{}],
             [
               %{"entity" => "snake-id-string", "segment_type" => :body},
               %{"entity" => :food, "segment_type" => nil},
               %{}
             ],
             [%{"entity" => "snake-id-string", "segment_type" => :head}, %{}, %{}]
           ] = updated_field
  end

  defp example_game do
    %{
      "game" => %{
        "id" => "game-id-string"
      },
      "turn" => 4,
      "board" => %{
        "height" => 3,
        "width" => 3,
        "food" => [
          %{
            "x" => 2,
            "y" => 2
          }
        ],
        "snakes" => [
          %{
            "id" => "snake-id-string",
            "name" => "Sneky Snek",
            "health" => 90,
            "body" => [
              %{
                "x" => 1,
                "y" => 3
              },
              %{
                "x" => 1,
                "y" => 2
              },
              %{
                "x" => 1,
                "y" => 1
              }
            ]
          }
        ]
      },
      "you" => %{
        "id" => "snake-id-string",
        "name" => "Sneky Snek",
        "health" => 90,
        "body" => [
          %{
            "x" => 1,
            "y" => 3
          }
        ]
      }
    }
  end
end

defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "greets the world" do
    trigger = %{
      "body" => %{
        "command_type" => "Hackathon.Counter.IncrementCount",
        "version" => 1,
        "counter_id" => "asdf"
      }
    }

    assert Example.hello(trigger, %{}) == {:ok, %{}}
  end
end

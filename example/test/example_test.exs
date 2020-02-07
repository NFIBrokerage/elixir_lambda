defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "greets the world" do
    trigger_json = %{
      "body" => %{
        "command_type" => "Hackathon.Counter.IncrementCount",
        "version" => 1,
        "counter_id" => "asdf"
      }
    }

    assert Example.hello(trigger_json, %{}) == {:ok, %{}}
  end
end

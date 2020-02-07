defmodule Hackathon.Counter.Decider do
  @moduledoc false

  alias Hackathon.Counter.State

  def decide(
        %State{} = state,
        %{command_type: "Hackathon.Counter.IncrementCount", version: version} = command
      )
      when version >= 1 do
    event = %{
      event_type: "Hackathon.Counter.CountIncremented",
      version: 1,
      counter_id: command.counter_id,
      total_count: state.total_count + 1
    }

    {:ok, [event]}
  end
end

defmodule Hackathon.Counter.Evolver do
  @moduledoc false

  alias Hackathon.Counter.State

  def evolve(events, instance_id) when is_list(events) do
    Enum.reduce(events, State.initial_state(instance_id), &evolve/2)
  end

  def evolve(
        %{event_type: "Hackathon.Counter.CountIncremented", version: version} = event,
        %State{} = state
      )
      when version >= 1 do
    Map.update!(state, :total_count, fn count -> count + 1 end)
  end
end

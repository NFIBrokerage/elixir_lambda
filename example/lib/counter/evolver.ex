defmodule Hackathon.Counter.Evolver do
  @moduledoc false

  alias Hackathon.Counter.State

  def evolve(events, instance_id) when is_list(events) do
    Enum.reduce(events, State.initial_state(instance_id), &evolve/2)
  end

  def evolve(
        %{event_type: "Hackathon.Counter.CountIncremented", version: version} =
          event,
        %State{} = state
      )
      when version >= 1 do
    state
  end

  def evolve(_event, state) do
    state
  end
end

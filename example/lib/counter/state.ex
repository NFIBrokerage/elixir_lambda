defmodule Hackathon.Counter.State do
  @moduledoc false

  defstruct [:counter_id, :total_count]

  def initial_state(instance_id) do
    %__MODULE__{
      counter_id: instance_id,
      total_count: 0
    }
  end
end

defmodule Hackathon.Counter.CommandHandler do
  @moduledoc false

  require Logger

  alias Hackathon.Counter.{AggregateRepo, Decider}

  def handle_command(command) do
    Logger.debug(fn -> "#{inspect(__MODULE__)} handling #{inspect(command)}" end)

    instance_id = command.counter_id

    aggregate_state = AggregateRepo.fetch_aggregate_state(instance_id)
    {:ok, events} = Decider.decide(aggregate_state, command)
    :ok = AggregateRepo.persist_events(events, instance_id)

    :ok
  end
end

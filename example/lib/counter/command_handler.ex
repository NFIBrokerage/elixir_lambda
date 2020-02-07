defmodule Hackathon.Counter.CommandHandler do
  @moduledoc false

  require Logger

  alias Hackathon.Counter.{AggregateRepo, Decider}

  def handle_command(command) do
    Logger.debug(fn -> "#{inspect(__MODULE__)} handling #{inspect(command)}" end)

    instance_id = command.counter_id

    event_history = AggregateRepo.fetch_aggregate_event_history(instance_id)
    Logger.info(fn -> "fetched event history for #{instance_id}: inspect(event_history)" end)

    aggregate_state = AggregateRepo.fetch_aggregate_state(instance_id)
    {:ok, events} = Decider.decide(aggregate_state, command)
    :ok = AggregateRepo.persist_events(events, instance_id)

    :ok
  end
end

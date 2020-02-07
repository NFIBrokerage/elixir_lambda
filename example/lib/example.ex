defmodule Example do
  @moduledoc """
  Example Lambda function.
  """

  require Logger

  def hello(event, context) do
    Logger.info("Event: #{inspect(event)}")
    Logger.info("Context: #{inspect(context)}")

    ex_stream_client_settings = [
      db_type: :node,
      port: 1113,
      reconnect_delay: 2_000,
      max_attempts: :infinity,
      host: "kestrel52.app.relaytms.com",
      username: "admin",
      password: "changeit",
      connection_name: "elixir lambda hello"
    ]

    {:ok, ex_stream_client_pid} = ExStreamClient.start_link(ex_stream_client_settings)

    Logger.info("Connected to EventStore #{inspect(ex_stream_client_pid)}")

    counter_id = UUID.uuid4()

    event = %{
      event_type: "Hackathon.Counter.CounterIncremented",
      version: 1,
      counter_id: counter_id,
      total_count: 42
    }

    :ok = Hackathon.Counter.AggregateRepo.persist_events([event], counter_id)

    events = Hackathon.Counter.AggregateRepo.fetch_aggregate_event_history(counter_id)

    Logger.info("Counter #{counter_id} event history is #{inspect(events)}")

    # At one point we thought we needed to explicitly stop the ExStream worker
    # to avoid sporadic failures. That's since been cast in doubt.
    GenServer.stop(ex_stream_client_pid)

    # need to return an empty map because the default API Gateway response
    # proxy only accepts an empty json response
    {:ok, %{}}
  end
end

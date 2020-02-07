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
    Process.sleep(1000)

    Logger.info("Look Ma!!! I made a UUID!! #{inspect(UUID.uuid4())}")

    # If the ExStreamClient isn't stopped, we get sporadic failures from
    # repeated lambda calls.
    GenServer.stop(ex_stream_client_pid)

    # need to return an empty map because the default API Gateway response
    # proxy only accepts an empty json response
    {:ok, %{}}
  end
end

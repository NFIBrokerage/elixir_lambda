defmodule Example do
  @moduledoc """
  Example Lambda function.
  """

  require Logger

  def hello(trigger, context) do
    Logger.info("Trigger: #{inspect(trigger)}")
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

    command = trigger |> Poison.decode!(keys: :atoms) |> Map.get(:body)

    Hackathon.Counter.CommandHandler.handle_command(command)

    # At one point we thought we needed to explicitly stop the ExStream worker
    # to avoid sporadic failures. That's since been cast in doubt.
    GenServer.stop(ex_stream_client_pid)

    # need to return an empty map because the default API Gateway response
    # proxy only accepts an empty json response
    {:ok, %{}}
  end
end

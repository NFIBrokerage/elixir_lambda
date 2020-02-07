defmodule Example do
  @moduledoc """
  Example Lambda function.
  """

  import Ecto.Query, only: [from: 2]
  require Logger

  def hello(trigger, context) do
    Logger.info("Trigger: #{inspect(trigger)}")
    Logger.info("Context: #{inspect(context)}")

    # db_config = [
    #   database: "agora_blue",
    #   username: "agora_admin",
    #   password: "watermeloncats",
    #   hostname: "hyperion52.app.relaytms.com",
    #   pool_size: 10
    # ]

    # Hackathon.Repo.start_link(db_config)
    repo_start_result = Hackathon.Repo.start_link()
    Logger.info("repo_start_result: #{inspect(repo_start_result)}")
    Logger.info(inspect(Hackathon.Repo.config()))

    query =
      from(sp in "stream_positions",
        select: sp.event_listener
      )

    # Send the query to the repository
    Logger.info("About to query")
    query_result = Hackathon.Repo.all(query)
    Logger.info("Query returned: #{inspect(query_result)}")

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

    # the LambdaRuntime decodes the top level of the trigger message as JSON
    # but it does not recursively decode the entire trigger message
    command = trigger["body"] |> Poison.decode!(keys: :atoms)

    Hackathon.Counter.CommandHandler.handle_command(command)

    # At one point we thought we needed to explicitly stop the ExStream worker
    # to avoid sporadic failures. That's since been cast in doubt.
    GenServer.stop(ex_stream_client_pid)

    # need to return an empty map because the default API Gateway response
    # proxy only accepts an empty json response
    {:ok, %{}}
  end
end

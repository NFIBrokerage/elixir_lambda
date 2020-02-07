defmodule Hackathon.Repo do
  @moduledoc false

  use ReadModelRepo.EctoRepo,
    otp_app: :hackathon,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    {:ok, place_connection_identifier(config, connection_identifier())}
  end

  defp connection_identifier() do
    "hackathon-lambda"
  end

  defp place_connection_identifier(config, identifier) do
    case is_nil(config[:parameters]) do
      true ->
        put_in(config, [:parameters], application_name: identifier)

      _ ->
        # coveralls-ignore-start
        put_in(config, [:parameters, :application_name], identifier)
        # coveralls-ignore-stop
    end
  end
end

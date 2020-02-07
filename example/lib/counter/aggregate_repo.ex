options = [
  ex_stream_client_module: ExStreamClient,
  evolver: Hackathon.Counter.Evolver,
  es_category_delimeter: "-",
  aggregate_event_stream_env_postfix: "",
  aggregate_type: "Hackathon.Counter"
]

AggregateRepo.define(Hackathon.Counter.AggregateRepo, options)

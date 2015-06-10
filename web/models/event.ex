defmodule HelloPhoenix.Event do
  defstruct [:id, :type, :data]

  require Record
  Record.defrecord :cql_query, statement: nil, values: [], reusable: :undefined,
    named: false, page_size: 100, page_state: :undefined, consistency: 1,
    serial_consistency: :undefined, value_encode_handler: :undefined

  def all do
    {ok, client} = :cqerl.new_client({})
    {ok, result} = :cqerl.run_query(client, "SELECT * FROM stats_development.events;")
    :cqerl.close_client(client)
    Enum.map(
      :cqerl.all_rows(result),
      fn(x) ->
        %HelloPhoenix.Event{
          id: x[:id],
          type: x[:type],
          data: x[:data]
        }
      end
    )
  end

  def create(params) do
    event = %HelloPhoenix.Event{
      id: UUID.string_to_binary!(Ecto.UUID.generate()),
      type: params["type"],
      data: if params["data"] == nil do [] else Enum.into(params["data"], []) end
    }
    {ok, errors} = validate(event)
    if ok == :ok do
      store(event)
    else
      { ok, errors }
    end
  end

  defp validate(event) do
    errors = []
    if event.type == nil do
      errors = errors ++ ["You must provide an event type"]
    end
    if length(errors) > 0 do
      { false, errors }
    else
      { :ok, :void }
    end
  end

  defp store(event) do
    {ok, client} = :cqerl.new_client({})
    {ok, result} = :cqerl.run_query(client, cql_query(
      statement: "INSERT INTO stats_development.events(id, type, data) VALUES(:id, :type, :data);",
      values: [
        id: event.id,
        type: event.type,
        data: event.data
      ]
    ))
    :cqerl.close_client(client)
    if ok == :ok do
      {ok, event}
    else
      {ok, elem(result, 1)}
    end
  end
end

defimpl Poison.Encoder, for: HelloPhoenix.Event do
  def encode(event, _options) do
    %{
      id: UUID.binary_to_string!(event.id),
      type: event.type,
      data: if event.data == :null do nil else Enum.into(event.data, %{}) end
    } |> Poison.Encoder.encode([])
  end
end

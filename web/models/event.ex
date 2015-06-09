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
          id: UUID.binary_to_string!(x[:id]),
          type: x[:type],
          data: if x[:data] == :null do nil else Enum.into(x[:data], %{}) end
        }
      end
    )
  end

  def create(params) do
    {ok, client} = :cqerl.new_client({})
    {ok, result} = :cqerl.run_query(client, cql_query(
      statement: "INSERT INTO stats_development.events(id, type, data) VALUES(:id, :type, :data);",
      values: [
        id: UUID.string_to_binary!(Ecto.UUID.generate()),
        type: params["type"],
        data: Enum.into(params["data"], [])
      ]
    ))
    :cqerl.close_client(client)
    ok == :ok
  end
end

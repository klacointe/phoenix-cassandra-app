defmodule HelloPhoenix.EventController do
  use HelloPhoenix.Web, :controller

  require UUID

  plug :action

  def index(conn, _params) do
    render conn, events: HelloPhoenix.Event.all
  end

  def create(conn, _params) do
    {ok, result} = HelloPhoenix.Event.create(_params)
    if ok == :ok do
      conn
      |> put_status(201)
      |> render "create.json", item: result
    else
      conn
      |> put_status(400)
      |> render "create.json", errors: result
    end
  end

end

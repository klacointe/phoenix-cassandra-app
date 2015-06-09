defmodule HelloPhoenix.EventController do
  use HelloPhoenix.Web, :controller

  require UUID

  plug :action

  def index(conn, _params) do
    render conn, events: HelloPhoenix.Event.all
  end

  def create(conn, _params) do
    if HelloPhoenix.Event.create(_params) do
      conn
      |> send_resp(201, "")
    else
      conn
      |> send_resp(400, "")
    end
  end

end

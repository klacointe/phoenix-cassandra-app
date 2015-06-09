defmodule HelloPhoenix.EventView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{events: events}) do
    events
  end
end

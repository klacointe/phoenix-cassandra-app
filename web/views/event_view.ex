defmodule HelloPhoenix.EventView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{events: events}) do
    events
  end

  def render("create.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("create.json", %{item: event}) do
    event
  end
end

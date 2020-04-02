defmodule GameTestWeb.Api.V1.PlayerView do
  use GameTestWeb, :view

  def render("index.json", %{players: players}) do
    render_many(players, __MODULE__, "player.json")
  end

  def render("show.json", %{player: player}) do
    render_one(player, __MODULE__, "player.json")
  end

  def render("player.json", %{player: player}) do
    %{
      name: player.name,
      x: player.x,
      y: player.y,
      status: player.status
    }
  end
end

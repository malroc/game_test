defmodule GameTestWeb.Api.V1.PlayerController do
  use GameTestWeb, :controller

  alias GameTest.Engine

  def update(conn, %{id: name, moving: direction}) do
    GenServer.cast(Engine, {:move_player, name, direction})
    %{players: %{^name => player}} = GenServer.call(Engine, :state)

    render(conn, "show.json", player: player)
  end

  def update(conn, %{id: name, atacking: true}) do
    GenServer.cast(Engine, {:atack_other_players, name})
    %{players: %{^name => player}} = GenServer.call(Engine, :state)

    render(conn, "show.json", player: player)
  end

  def index(conn, _params) do
    %{players: players} = GenServer.call(Engine, :state)

    render(conn, "index.json", players: players)
  end
end

defmodule GameTestWeb.Api.V1.PlayerController do
  use GameTestWeb, :controller

  alias GameTest.Engine

  def update(conn, %{"id" => name, "moving" => direction}) do
    case get_session(conn, :current_user_name) do
      ^name ->
        player = GenServer.call(Engine, {:move_player, name, String.to_atom(direction)})
        render(conn, "show.json", player: player)

      _ ->
        put_status(conn, :unauthorized)
    end
  end

  def update(conn, %{"id" => name, "atacking" => true}) do
    case get_session(conn, :current_user_name) do
      ^name ->
        player = GenServer.call(Engine, {:atack_other_players, name})
        render(conn, "show.json", player: player)

      _ ->
        put_status(conn, :unauthorized)
    end
  end

  def index(conn, _params) do
    %{players: players} = GenServer.call(Engine, :state)

    render(conn, "index.json", players: Enum.map(players, fn {_k, v} -> v end))
  end
end

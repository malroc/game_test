defmodule GameTestWeb.Api.V1.PlayerController do
  use GameTestWeb, :controller

  alias GameTest.Engine

  def update(conn, %{"id" => name} = params) do
    case get_session(conn, :current_player_name) do
      ^name ->
        player = update_player(name, Map.delete(params, "id"))
        render(conn, "show.json", player: player)

      _ ->
        put_status(conn, :unauthorized)
    end
  end

  defp update_player(name, %{"status" => "respawning"}) do
    GenServer.call(Engine, {:schedule_respawn_player, name})
  end

  defp update_player(name, %{"moving" => direction}) do
    GenServer.call(Engine, {:move_player, name, String.to_atom(direction)})
  end

  defp update_player(name, %{"attacking" => true}) do
    GenServer.call(Engine, {:attack_other_players, name})
  end

  def index(conn, _params) do
    %{players: players} = GenServer.call(Engine, :state)

    render(conn, "index.json", players: Enum.map(players, fn {_k, v} -> v end))
  end
end

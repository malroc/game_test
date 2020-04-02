defmodule GameTestWeb.Api.V1.PlayerControllerTest do
  use GameTestWeb.ConnCase

  setup do
    current_player_name =
      build_conn()
      |> get("/")
      |> get_session(:current_player_name)

    {:ok, current_player_name: current_player_name}
  end

  test "GET /api/v1/players", %{conn: conn, current_player_name: current_player_name} do
    conn = get(conn, "/api/v1/players")
    assert [%{"name" => ^current_player_name}] = json_response(conn, 200)
  end
end

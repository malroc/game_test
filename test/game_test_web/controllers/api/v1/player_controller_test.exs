defmodule GameTestWeb.Api.V1.PlayerControllerTest do
  use GameTestWeb.ConnCase

  setup do
    current_user_name =
      build_conn()
      |> get("/")
      |> get_session(:current_user_name)

    {:ok, current_user_name: current_user_name}
  end

  test "GET /api/v1/players", %{conn: conn, current_user_name: current_user_name} do
    conn = get(conn, "/api/v1/players")
    assert [%{"name" => ^current_user_name}] = json_response(conn, 200)
  end
end

defmodule GameTestWeb.PageController do
  use GameTestWeb, :controller

  alias GameTest.Engine

  def index(conn, %{"name" => name}) do
    conn =
      with ^name <- get_session(conn, :current_user_name),
           false <- is_nil(name),
           %{players: %{^name => _player}} <- GenServer.call(Engine, :state) do
        conn
      else
        _ ->
          player = GenServer.call(Engine, {:maybe_create_player, name})
          put_session(conn, :current_user_name, player.name)
      end

    render(conn, "index.html")
  end

  def index(conn, _params) do
    conn =
      with name <- get_session(conn, :current_user_name),
           false <- is_nil(name),
           %{players: %{^name => _player}} <- GenServer.call(Engine, :state) do
        conn
      else
        _ ->
          player = GenServer.call(Engine, :create_player)
          put_session(conn, :current_user_name, player.name)
      end

    render(conn, "index.html")
  end
end

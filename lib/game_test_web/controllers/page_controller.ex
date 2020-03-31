defmodule GameTestWeb.PageController do
  use GameTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

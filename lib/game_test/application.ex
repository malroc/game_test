defmodule GameTest.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GameTestWeb.Endpoint,
      GameTest.Engine
    ]

    opts = [strategy: :one_for_one, name: GameTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    GameTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

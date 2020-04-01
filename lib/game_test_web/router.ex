defmodule GameTestWeb.Router do
  use GameTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api/v1", GameTestWeb.Api.V1 do
    pipe_through :api

    resources "/players", PlayerController, only: [:index, :update]
  end

  scope "/", GameTestWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameTestWeb do
  #   pipe_through :api
  # end
end

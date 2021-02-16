defmodule FinderWeb.Router do
  use FinderWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Finder.Guardian.AuthPipeline
  end

  pipeline :authenticated do
    plug :accepts, ["json"]
    plug Finder.Guardian.AuthPipeline
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
    plug Finder.Plugs.CurrentUser
  end

  scope "/api/v1", FinderWeb do
    pipe_through [:api]

    resources "/rooms", RoomController, except: [:new, :edit]
    resources "/districts", DistrictController, only: [:index, :show]
    resources "/amenities", AmenityController, only: [:index]
    resources "/waters", WaterController, only: [:index]
    resources "/parkings", ParkingController, only: [:index]
    resources "/users", UserController, except: [:new, :edit]
    post "/login", SessionController, :login
    post "/appinfo", AppinfoController, :index
    post "/search_room", RoomController, :search

    pipe_through [:authenticated]
    get "/my_rooms", RoomController, :my_rooms
    resources "/chats", ChatController, only: [:index, :create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: FinderWeb.Telemetry
    end
  end
end

defmodule Finder.Guardian.ProtectedPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :finder,
    module: Finder.Guardian,
    error_handler: Finder.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule Finder.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :finder,
    module: Finder.Guardian,
    error_handler: Finder.AuthErrorHandler
end

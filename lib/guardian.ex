defmodule Finder.Guardian do
  use Guardian, otp_app: :finder

  def subject_for_token(user, _claims) do
    IO.puts("subject_for_token")
    IO.inspect(user)
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    IO.puts("subject_for_token")
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    IO.puts("resource_from_claims")
    IO.inspect(id)

    try do
      resource = Finder.Accounts.get_user!(id)
      {:ok, resource}
    rescue
      Ecto.NoResultsError ->
        {:error, :not_found}
    end
  end

  def resource_from_claims(_claims) do
    IO.puts("subject_for_token")
    {:error, :reason_for_error}
  end
end

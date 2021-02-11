defmodule Finder.Guardian do
  use Guardian, otp_app: :finder

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    try do
      resource = Finder.Accounts.get_user!(id)
      {:ok, resource}
    rescue
      Ecto.NoResultsError ->
        {:error, :not_found}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end

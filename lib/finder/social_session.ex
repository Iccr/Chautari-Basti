defmodule Finder.SocialSession do
  alias Finder.Accounts

  def verify_token(attrs) do
    provider = attrs["provider"]
    token = attrs["token"]

    case provider do
      "facebook" ->
        verify_facebook_token(token)

      "google" ->
        verify_google_token(token)
    end
  end

  defp verify_google_token(token) do
    url = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" <> token
    {:ok, response} = call_api(url)
    parse_google_response(response)
  end

  defp verify_facebook_token(token) do
    url =
      "https://graph.facebook.com/me?fields=name,first_name,last_name,email,picture&access_token=" <>
        token

    {:ok, response} =
      Task.async(fn -> HTTPoison.get(url) end)
      |> Task.await()

    parse_fb_response(response)
  end

  defp parse_google_response(response) do
    jsn = Jason.decode(response.body)
    IO.puts("jsn is")
    IO.inspect(jsn)

    case jsn do
      {:ok, %{"error_description" => message}} ->
        {:error, message}

      {:ok, %{"name" => name, "email" => email}} ->
        {:ok, name, email}

      {:error, _} ->
        {:error, "not allowed"}
    end
  end

  defp call_api(url) do
    Task.async(fn -> HTTPoison.get(url) end)
    |> Task.await()
  end

  defp parse_fb_response(response) do
    jsn = Jason.decode(response.body)

    case jsn do
      {:ok, %{"error" => %{"message" => message}}} ->
        {:error, message}

      {:ok, %{"name" => name, "email" => email}} ->
        {:ok, name, email}

      {:error, _} ->
        {:error, "not allowed"}
    end
  end

  def get_user_from_params(%{"email" => email, "token" => token}) do
    case Accounts.get_user_with_email(email) do
      nil ->
        Accounts.get_user_with_token(token)

      user ->
        user
    end
  end

  defp get_user_with_email_token(%{"email" => email, "token" => token}) do
    Accounts.get_user_with_email_token(email, token)
  end

  defp get_user_with_email_token(%{"token" => token}) do
    Accounts.get_user_with_email_token(nil, token)
  end
end

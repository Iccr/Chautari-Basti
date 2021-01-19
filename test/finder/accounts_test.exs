defmodule Finder.AccountsTest do
  use Finder.DataCase

  alias Finder.Accounts

  describe "users" do
    alias Finder.Accounts.User

    @valid_attrs %{
      email: "some email",
      imageurl: "some imageurl",
      name: "some name",
      token: "abcdefgh",
      provider: "facebook"
    }
    @update_attrs %{
      email: "some updated email",
      imageurl: "some updated imageurl",
      name: "some updated name",
      token: "abcdefghij",
      provider: "google"
    }
    @invalid_attrs %{email: nil, imageurl: nil, name: nil, token: nil, provider: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.imageurl == "some imageurl"
      assert user.name == "some name"
      assert user.token == "abcdefgh"
      assert user.provider == "facebook"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.imageurl == "some updated imageurl"
      assert user.name == "some updated name"
      assert user.token == "abcdefghij"
      assert user.provider == "google"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    # test "find user with email returns a user with that email" do
    #   user = user_fixture()
    #   email = "some email"
    #   result = Accounts.get_user_with_email(email)
    #   assert user.email == result.email
    # end

    # test "find user with token returns a user with that token" do
    #   user = user_fixture()
    #   token = "abcdefgh"
    #   result = Accounts.get_user_with_token(token)
    #   assert user.token == result.token
    # end

    # test "find user with either token  or email" do
    #   user = user_fixture()
    #   result = Accounts.get_user_with_email_token(user.email, user.token)
    #   assert user.email == result.email
    #   assert user.token == result.token
    # end

    # test "finder user with token if email is not present" do
    #   user = user_fixture()
    #   result = Accounts.get_user_with_email_token(nil, user.token)

    #   assert user.token == result.token
    # end
  end
end

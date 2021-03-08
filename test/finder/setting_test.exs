defmodule Finder.SettingTest do
  use Finder.DataCase

  alias Finder.Setting

  describe "appinfo" do
    alias Finder.Setting.AppInfo

    @valid_attrs %{android_version: "some android_version", app_key: "some app_key", force_update: "some force_update", ios_version: "some ios_version"}
    @update_attrs %{android_version: "some updated android_version", app_key: "some updated app_key", force_update: "some updated force_update", ios_version: "some updated ios_version"}
    @invalid_attrs %{android_version: nil, app_key: nil, force_update: nil, ios_version: nil}

    def app_info_fixture(attrs \\ %{}) do
      {:ok, app_info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Setting.create_app_info()

      app_info
    end

    test "list_appinfo/0 returns all appinfo" do
      app_info = app_info_fixture()
      assert Setting.list_appinfo() == [app_info]
    end

    test "get_app_info!/1 returns the app_info with given id" do
      app_info = app_info_fixture()
      assert Setting.get_app_info!(app_info.id) == app_info
    end

    test "create_app_info/1 with valid data creates a app_info" do
      assert {:ok, %AppInfo{} = app_info} = Setting.create_app_info(@valid_attrs)
      assert app_info.android_version == "some android_version"
      assert app_info.app_key == "some app_key"
      assert app_info.force_update == "some force_update"
      assert app_info.ios_version == "some ios_version"
    end

    test "create_app_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Setting.create_app_info(@invalid_attrs)
    end

    test "update_app_info/2 with valid data updates the app_info" do
      app_info = app_info_fixture()
      assert {:ok, %AppInfo{} = app_info} = Setting.update_app_info(app_info, @update_attrs)
      assert app_info.android_version == "some updated android_version"
      assert app_info.app_key == "some updated app_key"
      assert app_info.force_update == "some updated force_update"
      assert app_info.ios_version == "some updated ios_version"
    end

    test "update_app_info/2 with invalid data returns error changeset" do
      app_info = app_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Setting.update_app_info(app_info, @invalid_attrs)
      assert app_info == Setting.get_app_info!(app_info.id)
    end

    test "delete_app_info/1 deletes the app_info" do
      app_info = app_info_fixture()
      assert {:ok, %AppInfo{}} = Setting.delete_app_info(app_info)
      assert_raise Ecto.NoResultsError, fn -> Setting.get_app_info!(app_info.id) end
    end

    test "change_app_info/1 returns a app_info changeset" do
      app_info = app_info_fixture()
      assert %Ecto.Changeset{} = Setting.change_app_info(app_info)
    end
  end
end

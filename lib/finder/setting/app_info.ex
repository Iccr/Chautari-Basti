defmodule Finder.Setting.AppInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appinfo" do
    field :android_version, :string
    field :app_key, :string
    field :force_update, :boolean
    field :ios_version, :string

    timestamps()
  end

  @doc false
  def changeset(app_info, attrs) do
    app_info
    |> cast(attrs, [:android_version, :ios_version, :app_key, :force_update])
    |> validate_required([:android_version, :ios_version, :force_update])
  end
end

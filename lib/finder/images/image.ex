defmodule Finder.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema

  schema "images" do
    field :image, Finder.ImageUploader.Type
    belongs_to :room, Finder.Rooms.Room
    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    attrs = put_random_filename(attrs)

    image
    |> cast(attrs, [:image])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end

  defp put_random_filename(%{image: %Plug.Upload{filename: name} = image} = params) do
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{params | image: image}
  end

  defp put_random_filename(params), do: params

  defp random_filename(name) do
    extension = Path.extname(name)

    file_name =
      Path.basename(name, extension)
      |> String.split()
      |> Enum.join()

    time = DateTime.utc_now()

    time =
      "#{time}"
      |> String.split(".")
      |> Enum.join()
      |> String.split(":")
      |> Enum.join()

    "#{file_name}_#{time}#{extension}"
  end
end

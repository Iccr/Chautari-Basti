defmodule FinderWeb.ChangesetView do
  use FinderWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `FinderWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    errors =
      Enum.map(changeset.errors, fn x ->
        {name, {val, _}} = x
        %{"name" => name, "value" => val}
      end)

    %{errors: errors}
  end
end

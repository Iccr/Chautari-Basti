defmodule Finder.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Finder.Repo

  alias Finder.Chats.Conversation
  alias Finder.Chats.Messages

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  def list_conversations do
    Repo.all(Conversation)
  end

  @doc """
  Gets a single conversation.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation!(123)
      %Conversation{}

      iex> get_conversation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation!(id), do: Repo.get!(Conversation, id)

  @doc """
  Creates a conversation.

  ## Examples

      iex> create_conversation(%{field: value})
      {:ok, %Conversation{}}

      iex> create_conversation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation.

  ## Examples

      iex> update_conversation(conversation, %{field: new_value})
      {:ok, %Conversation{}}

      iex> update_conversation(conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a conversation.

  ## Examples

      iex> delete_conversation(conversation)
      {:ok, %Conversation{}}

      iex> delete_conversation(conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation changes.

  ## Examples

      iex> change_conversation(conversation)
      %Ecto.Changeset{data: %Conversation{}}

  """
  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end

  def list_user_conversations(user) do
    Repo.preload(user, recipient_conversations: [:messages, :recipient, :sender])
  end

  def find_with_my_id_and_recipient_id(%{"sender_id" => sender_id, "recipient_id" => recipient_id}) do
    IO.puts("find_with_my_id_and_recipient_id")

    query =
      from c in Conversation,
        where: c.sender_id == ^sender_id and c.recipient_id == ^recipient_id,
        preload: [:messages, :sender, :recipient]

    Repo.all(query)
  end

  def create_message(
        %{
          "sender_id" => _sender_id,
          "conversation_id" => _conversation_id,
          "content" => _content
        } = attrs
      ) do
    %Messages{}
    |> Messages.changeset(attrs)
    |> Repo.insert()
  end

  def get_messages_for_conversation_id(conversation_id) do
    query =
      from m in Messages,
        where: m.conversation_id == ^conversation_id

    Repo.all(query)
  end
end

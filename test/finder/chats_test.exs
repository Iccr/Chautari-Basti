defmodule Finder.ChatsTest do
  use Finder.DataCase

  alias Finder.Chats

  describe "conversations" do
    alias Finder.Chats.Conversation

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def conversation_fixture(attrs \\ %{}) do
      {:ok, conversation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chats.create_conversation()

      conversation
    end

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Chats.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Chats.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      assert {:ok, %Conversation{} = conversation} = Chats.create_conversation(@valid_attrs)
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{} = conversation} = Chats.update_conversation(conversation, @update_attrs)
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_conversation(conversation, @invalid_attrs)
      assert conversation == Chats.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Chats.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Chats.change_conversation(conversation)
    end
  end
end

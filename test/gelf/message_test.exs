defmodule Gelfex.MessageTest do
  use ExUnit.Case

  alias Gelfex.Message, as: Message

  test "creates a new message" do
    assert %Message{version: "1.1", level: 1, short_message: "Short message"} = Message.create(1, "Short message")
  end
end

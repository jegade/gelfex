defmodule Gelfex.Message do
  defstruct version: "1.1",
            host: nil,
            short_message: "",
            full_message: nil,
            timestamp: nil,
            level: 1,
            additionals: %{}

  def create(level, short_message, full_message \\ nil, additionals \\ %{}) when is_integer(level) do
      %Gelfex.Message{
          host: :erlang.node(),
          short_message: short_message,
          full_message: full_message,
          level: level,
          additionals: additionals
      }
  end
end

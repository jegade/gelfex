defmodule Gelfex do
  use Application

  def start(_type, _args) do
    Gelfex.Supervisor.start_link
  end
end

defmodule Gelfex.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @connection_name Gelfex.Connection

  def init(:ok) do
    config = Application.get_all_env(:gelfex)

    children = [
      worker(Gelfex.Connection, [config[:hostname], config[:port], [], [name: @connection_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

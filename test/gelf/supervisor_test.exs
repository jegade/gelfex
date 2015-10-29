defmodule Gelfex.SupervisorTest do
  use ExUnit.Case

  setup do
    Application.put_env(:gelfex, :hostname, "127.0.0.1")
    Application.put_env(:gelfex, :port, 12201)
  end

  test "starts the supervisor" do
    pid = Process.whereis(Gelfex.Supervisor)
    children = Supervisor.which_children(pid)
    assert 1 == Enum.count(children)
  end
end

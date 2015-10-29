defmodule Gelfex.Connection do

  use Connection

  alias Gelfex.Message, as: Message

  def start_link(host, port, tcp_opts \\ [], opts \\ [], timeout \\ 5000) do
    Connection.start_link(__MODULE__, {host, port, tcp_opts, timeout}, opts)
  end

  def send(%Message{} = msg), do: Connection.call(__MODULE__, {:send, msg})

  def recv(bytes, timeout \\ 3000) do
    Connection.call(__MODULE__, {:recv, bytes, timeout})
  end

  def close, do: Connection.call(__MODULE__, :close)

  def init({host, port, opts, timeout}) do
    s = %{host: host, port: port, opts: opts, timeout: timeout, sock: nil}
    {:connect, :init, s}
  end

  def connect(_, %{sock: nil, host: host, port: port, opts: opts, timeout: timeout} = s) do
    case :gen_tcp.connect(to_char_list(host), port, [active: false] ++ opts, timeout) do
      {:ok, sock} ->
        {:ok, %{s | sock: sock}}
      {:error, _msg} ->
        {:backoff, 1000, s}
    end
  end

  def disconnect(info, %{sock: sock} = s) do
    :ok = :gen_tcp.close(sock)
    case info do
      {:close, from} ->
        Connection.reply(from, :ok)
      {:error, :closed} ->
        :error_logger.format("Connection closed~n", [])
      {:error, reason} ->
        reason = :inet.format_error(reason)
        :error_logger.format("Connection error: ~s~n", [reason])
    end
    {:connect, :reconnect, %{s | sock: nil}}
  end

  def handle_call(_, _, %{sock: nil} = s) do
    {:reply, {:error, :closed}, s}
  end
  def handle_call({:send, msg}, _, %{sock: sock} = s) do
    json = msg |> Poison.encode!
    case :gen_tcp.send(sock, json <> <<0>>) do
      :ok ->
        {:reply, :ok, s}
      {:error, _} = error ->
        {:disconnect, error, error, s}
    end
  end
  def handle_call({:recv, bytes, timeout}, _, %{sock: sock} = s) do
    case :gen_tcp.recv(sock, bytes, timeout) do
      {:ok, _} = ok ->
        {:reply, ok, s}
      {:error, :timeout} = timeout ->
        {:reply, timeout, s}
      {:error, _} = error ->
        {:disconnect, error, error, s}
    end
  end
  def handle_call(:close, from, s) do
    {:disconnect, {:close, from}, s}
  end
end

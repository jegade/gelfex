# Gelfex

Elixir client for logging GELF messages to Graylog.

At this time only the GELF TCP input is supported.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add gelfex to your list of dependencies in `mix.exs`:

        def deps do
          [{:gelfex, "~> 0.0.1"}]
        end

  2. Ensure gelfex is started before your application:

        def application do
          [applications: [:gelfex]]
        end

## Configuration
In your applications config.exs you will need a new section for customizing the connection to Graylog

```elixir
config :gelfex,
  host: "graylog.local",
  port: "112201"
```

## Usage
To create a message and send it to Graylog:
```elixir
message = Gelfex.Message.create(1, "This is my short message", "This is my long message")
{:ok} = Gelfex.Connection.send(message)
```

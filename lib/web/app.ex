defmodule Web.App do  
  use Application.Behaviour
  require Lager

  def run(opts) do
    port = case opts[:port] do
      nil -> 4000
      _ -> opts[:port]
    end
    Lager.info "Starting Web on port #{port}..."

    opts = opts ++ [
      dispatch: Web.Dispatcher.dispatch
    ]
    Plug.Adapters.Cowboy.http Web.Plug, [], opts
  end

  def start do
    case :application.start(:web) do
      :ok -> :ok
      {:error, {:already_started, :web}} -> :ok
    end
  end

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Web.Supervisor.start_link
  end

  def stop(_state) do
    :ok
  end
end
defmodule BattleSnake2019.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: BattleSnake2019.Web.Router,
        options: [port: Application.get_env(:battle_snake_2019, :port)]
      ),
      # store games
      {BattleSnake2019.GameServer, name: :game_server}
      # Starts a worker by calling: BattleSnake2019.Worker.start_link(arg)
      # {BattleSnake2019.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BattleSnake2019.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

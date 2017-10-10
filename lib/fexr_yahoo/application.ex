defmodule FexrYahoo.Application do
  @moduledoc false

  use Application
  
  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ConCache, [[ttl_check: :timer.seconds(1), ttl: :timer.seconds(450)], [name: :yahoo]],[ id: :yahoo, modules: [ConCache]])
    ]

    opts = [strategy: :one_for_one, name: FexrYahoo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule GenStageStudy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # {:ok, producer} = GenStage.start_link(GenStageStudy.Producer, :ok)
    # {:ok, consumer} = GenStage.start_link(GenStageStudy.Consumer, :ok)
    # GenStage.sync_subscribe(consumer,
    #   to: producer,
    #   min_demand: 1,
    #   max_demand: 2)

    # List all child processes to be supervised
    import Supervisor.Spec
    children = [
      worker(GenStageStudy.Producer, []),
      worker(GenStageStudy.Consumer, [], id: :consumer1),
      worker(GenStageStudy.Consumer, [], id: :consumer2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenStageStudy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

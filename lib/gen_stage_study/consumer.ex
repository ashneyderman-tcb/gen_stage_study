defmodule GenStageStudy.Consumer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(_) do
    {:consumer, :ok, subscribe_to: [{GenStageStudy.Producer, min_demand: 0, max_demand: 1}]}
  end

  def handle_events(events, _from, :ok) do
    events = events |> Enum.filter(&( &1 != nil))
    case events do
      [] -> :ok
      _ -> IO.puts "[#{DateTime.utc_now |> DateTime.to_string}] #{inspect self()}: #{Enum.count(events)} events - #{inspect events, pretty: true}"
    end
    {:noreply, [], :ok}
  end
end
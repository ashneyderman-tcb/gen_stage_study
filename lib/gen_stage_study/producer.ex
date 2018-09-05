defmodule GenStageStudy.Producer do
  use GenStage
  require Logger

  alias GenStageStudy.EventsStream

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    {:ok, _} = EventsStream.init()
    :erlang.send_after(10_000, self(), :toggle_info)
    {:producer, {EventsStream.events(), false}}
  end

  def handle_demand(demand, {stream, false}) when demand > 0 do
    events = Enum.take(stream, demand)
    {:noreply, events, {stream, false}}
  end
  def handle_demand(demand, {stream, true}) when demand > 0 do
    IO.puts "[#{DateTime.utc_now |> DateTime.to_string}] Processing demand: #{inspect demand} ..."
    events = Enum.take(stream, demand)
    {:noreply, events, {stream, false}}
  end

  def handle_info(:toggle_info, {stream, _}) do
    :erlang.send_after(10_000, self(), :toggle_info)
    {:noreply, [], {stream, true}}
  end

  # def handle_demand(demand, stream) when demand > 0 do
  #   GenStage.cast(__MODULE__, demand)
  #   {:noreply, [], stream}
  # end
  # def handle_cast(demand, stream) when demand > 0 do
  #   events = Enum.take(stream, demand)
  #   {:noreply, events, stream}
  # end

end
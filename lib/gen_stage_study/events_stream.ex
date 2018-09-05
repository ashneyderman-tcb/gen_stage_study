defmodule GenStageStudy.EventsStream do

  def init do
    Agent.start(fn -> [1, 2, 3, 4, 5, 6] end, name: :stream)
  end

  def events do
    Stream.resource(
      fn ->
        case Agent.start(fn -> [] end, name: :stream) do
          {:ok, agent} -> agent
          {:error, {:already_started, agent}} -> agent
        end
      end,
      fn agent ->
        v = Agent.get_and_update(agent, fn([]) -> {nil, []}
                                          ([h | t]) -> {h, t}
                                        end)
        {[v], agent}
      end,
      fn _agent -> end
    )
  end

  def add_events(events) when is_list(events) do
    :ok = Agent.update(:stream, fn(state) -> events ++ state end)
  end

  def add_event(event) do
    add_events([event])
  end

end
defmodule BonyTrace.Tracer do
  use GenServer

  def ensure_start(pid) do
    case GenServer.whereis(__MODULE__) do
      p when is_pid(p) ->
        :ok

      _ ->
        start(pid)
    end
  end

  def stop(pid) do
    GenServer.cast(__MODULE__, {:stop, pid})
  end

  defp start(pid) do
    GenServer.start(__MODULE__, pid, name: __MODULE__)
  end

  @impl true
  def init(pid) do
    {:ok, %{pid => nil}}
  end

  @impl true
  def handle_info({:trace_ts, pid, :send, msg, to, ts}, state) do
    print_log("sent", pid, msg, to, ts, state[pid])
    {:noreply, %{state | pid => ts}}
  end

  @impl true
  def handle_info({:trace_ts, pid, :receive, msg, ts}, state) do
    print_log("received", pid, msg, nil, ts, state[pid])
    {:noreply, %{state | pid => ts}}
  end

  @impl true
  def handle_cast({:stop, pid}, state) do
    state = Map.delete(state, pid)

    case state do
      %{} ->
        {:stop, :normal, state}

      _ ->
        {:noreply, state}
    end
  end

  defp print_log(type, pid, msg, target, {_, s1, micros1} = ts, last_ts) do
    {_, s0, micros0} = last_ts || ts

    [
      """
      #{
        String.pad_trailing(
          "#{inspect(pid)} #{String.upcase(type)} #{
            if target do
              "TO: #{inspect(target)}"
            else
              ""
            end
          }",
          55
        )
      }+#{s1 - s0}.#{String.pad_leading("#{micros1 - micros0}", 6, "0")}s
      """,
      IO.ANSI.light_black(),
      "MESSAGE:",
      IO.ANSI.black(),
      " #{inspect(msg)}"
    ]
    |> IO.iodata_to_binary()
    |> IO.puts()
  end
end

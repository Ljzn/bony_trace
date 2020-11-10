defmodule BonyTrace.Tracer do
  use GenServer

  def ensure_start(pid) do
    case GenServer.whereis(__MODULE__) do
      p when is_pid(p) ->
        add_trace(pid)
        :ok

      _ ->
        start(pid)
    end
  end

  def add_trace(pid) do
    GenServer.cast(__MODULE__, {:add, pid})
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

  @impl true
  def handle_cast({:add, pid}, state) do
    {:noreply, Map.put_new(state, pid, nil)}
  end

  defp print_log(type, pid, msg, target, ts, last_ts) do
    last_ts = last_ts || ts

    type =
      case type do
        "sent" ->
          IO.ANSI.color(99) <> "SENT" <> IO.ANSI.black()

        "received" ->
          IO.ANSI.color(22) <> "RECEIVED" <> IO.ANSI.black()
      end

    [
      """
      #{
        String.pad_trailing(
          "#{inspect(pid)} #{type} #{
            if target do
              "TO: #{inspect(target)}"
            else
              ""
            end
          }",
          55
        )
      }+#{diffts(ts, last_ts)}s
      """,
      IO.ANSI.light_black(),
      "MESSAGE:",
      IO.ANSI.black(),
      " #{inspect(msg)}"
    ]
    |> IO.iodata_to_binary()
    |> IO.puts()
  end

  defp diffts({_, second1, micro_second1}, {_, second0, micro_second0}) do
    x = (second1 * 1_000_000 + micro_second1 - (second0 * 1_000_000 + micro_second0)) / 1_000_000
    :io_lib.format("~.6f", [x]) |> to_string()
  end
end

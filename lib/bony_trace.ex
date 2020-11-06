defmodule BonyTrace do
  @moduledoc """
  Documentation for `BonyTrace`.
  """

  defp trace_flags,
    do: [:send, :receive, :timestamp, {:tracer, GenServer.whereis(BonyTrace.Tracer)}]

  @doc """
  Start tracing pid.
  """
  def start(pid) do
    BonyTrace.Tracer.ensure_start(pid)
    :erlang.trace(pid, true, trace_flags())
  end

  @doc """
  Stop tracing pid.
  """
  def stop(pid) do
    try do
      :erlang.trace(pid, false, trace_flags())
    rescue
      ArgumentError ->
        :ok
    end

    BonyTrace.Tracer.stop(pid)
  end
end

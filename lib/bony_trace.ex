defmodule BonyTrace do
  @moduledoc """
  Documentation for `BonyTrace`.
  """

  defp trace_flags,
    do: [:send, :receive, :timestamp, {:tracer, GenServer.whereis(BonyTrace.Tracer)}]

  @doc """
  Start tracing pid.

  opts:
    - receiver: fun pid() -> any()
      a function be applied with the receiver's pid, the result will be printed
      at the same position.
  """
  def start(pid, opts \\ []) do
    BonyTrace.Tracer.ensure_start(pid, opts)
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

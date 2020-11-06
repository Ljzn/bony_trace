defmodule BonyTraceTest do
  use ExUnit.Case
  doctest BonyTrace

  test "tracing a simple process" do
    pid =
      spawn(fn ->
        BonyTrace.start(self())
        send(self(), :hi)

        receive do
          _msg ->
            :ok
        end
      end)

    # wait the tracer process started
    :timer.sleep(1000)
    t = GenServer.whereis(BonyTrace.Tracer)
    assert Process.alive?(t)
    BonyTrace.stop(pid)
    :timer.sleep(1000)
    refute Process.alive?(t)
  end
end

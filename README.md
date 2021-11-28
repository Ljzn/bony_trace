# BonyTrace

Print all messages sent or received by a process.

## How to use
```ex
iex> BonyTrace.start(Process.whereis(:init))
1
iex> :init.restart                          
:ok
#PID<0.0.0> <--                                                                      +0.000000s

  {#PID<0.548.0>, :get_status}

#PID<0.0.0> --> #PID<0.548.0>                                                        +0.000007s

  {:init, {:started, :started}}

#PID<0.0.0> <--                                                                      +0.000180s

  {:stop, :restart}

#PID<0.0.0> --> #PID<0.527.0>                                                        +0.000005s

  {:EXIT, #PID<0.492.0>, :shutdown}
```

You can also set a `:receiver` function to get more info from the recerver's pid:

```ex
spawn(fn ->
  BonyTrace.start(self(), receiver: &Process.info(&1, :initial_call))
  send(self(), :hi)

  receive do
    _msg ->
      # keep alive 1s
      :timer.sleep(1000)
      :ok
  end
end)
```

## Installation

adding `bony_trace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bony_trace, "~> 0.1.3", only: [:dev]}
  ]
end
```

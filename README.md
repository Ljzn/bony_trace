# BonyTrace

Print all messages sent or received by a process.


## How to use
```ex
> BonyTrace.start(pid)

#PID<0.162.0> SENT TO: #PID<0.162.0>                   +0.000000s
MESSAGE: :hi
#PID<0.162.0> RECEIVED                                 +0.000003s
MESSAGE: :hi

> BonyTrace.stop(pid)
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

```
#PID<0.205.0> SENT TO: #PID<0.205.0>                                  +0.000000s
MESSAGE: :hi
#PID<0.205.0> RECEIVED                                                +0.000003s
MESSAGE: :hi
#PID<0.207.0> SENT TO: {:initial_call, {:erlang, :apply, 2}}          +0.000000s
MESSAGE: :hi
#PID<0.207.0> RECEIVED                                                +0.000003s
MESSAGE: :hi
```

## Installation

adding `bony_trace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bony_trace, "~> 0.1.2", only: [:dev]}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bony_trace](https://hexdocs.pm/bony_trace).


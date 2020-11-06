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

## Installation

adding `bony_trace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bony_trace, "~> 0.1.0", only: [:dev]}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bony_trace](https://hexdocs.pm/bony_trace).


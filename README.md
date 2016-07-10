# FunLand

Algebraic Data Types in Elixir


### Roadmap

- [ ] Catcheable exceptions instead of raised strings.
- [ ] Find out how to implement Traversable properly in a dynamically typed language. (How do you know what to return when being passed an empty structure?)
- [ ] Add _let_ statements to the monadic do-notation.
- [ ] Fully Write this readme.
- [ ] Implement more practical Algebraic Data Types to show what can be done: List, Maybe, Either, Reader, Writer, Sum, Product, etc.
- [ ] Also, where to put these practical implementations?
- [ ] Write as many tests as possible.
- [ ] Revisit example code.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `fun_land` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:fun_land, "~> 0.1.0"}]
    end
    ```

  2. Ensure `fun_land` is started before your application:

    ```elixir
    def application do
      [applications: [:fun_land]]
    end
    ```


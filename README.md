# FunLand

Algebraic Data Types in Elixir


### Roadmap

- [x] Add _let_ statements to the monadic do-notation.
- [x] Also, where to put these practical implementations? -> FunLandic.*
- [ ] Catcheable exceptions instead of raised strings.
- [ ] Find out how to implement Traversable properly in a dynamically typed language. (How do you know what to return when being passed an empty structure?)
- [ ] Fully Write this readme.
- [ ] Implement more practical Algebraic Data Types to show what can be done: List, Maybe, Either, Reader, Writer, Sum, Product, etc.
- [ ] How to write proper code for the built-in types like List? (What to put in the monadic syntax? etc.)
- [ ] Write as many tests as possible.
- [ ] Revisit example code.
- [ ] Maybe include Comonad?
- [ ] Compare with `Monad` library (and thank for do-notation implementation understanding).



## Installation

If [available in Hex](https://hex.pm/docs/publish) (not yet!), the package can be installed as:

Add `fun_land` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:fun_land, "~> 0.1.0"}]
    end
    ```

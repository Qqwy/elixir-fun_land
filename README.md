# FunLand

Algebraic Data Types in Elixir


### Roadmap

- [x] The most commong Algebraic Data Types, built as Behaviours that can be added to your own modules/structs:
  - [x] *Mappable* - any structure you can `map` over: changing the contents without changing the structure.
  - [x] *Appliable* - any Mappable structure you can combine two of, where the first contains a function to `apply_with` the contents of the second, returning a new strucure.
  - [x] *Applicative* - any Appliable structure that can be created from any value you want to `wrap` inside.
  - [x] *Chainable* - any Appliable structure that you can `bind` functions to, which, when given the contents of the structure, return a new version of the structure.
  - [x] *Monad* - Anything structure that is both Applicative and Chainable, which makes them super flexible!
    - [x] Monadic do-notation. (The implementation is heavily based on code from the [monad](https://github.com/rmies/monad) library. Lots of thanks!)
      - [x] _let_ statements inside the monadic do-notation.
  - [x] *Semicombinable* - Anything which, when you have two of them, you can `combine` them together into one.
  - [x] *Combinable* - Anything that is Combinable, and also has a `neutral` value which you can combine something with when you don't have anything else, to keep the result the same.
  - [x] *CombinableMonad* - Any structure that is both a Monad and Combinable.
  - [ ] Traversable - TODO.
  - [ ] Comonad
- [x] Also, where to put these practical implementations? -> FunLandic.*
- [x] How to write proper code for the built-in types like List? (What to put in the monadic syntax? etc.)
- [ ] Catcheable exceptions instead of raised strings.
- [ ] Find out how to implement Traversable properly in a dynamically typed language. (How do you know what to return when being passed an empty structure?)
- [ ] Implement some practical Algebraic Data Types to show what can be done with them:
   - [x] List - the list we all know and love.
   - [x] Maybe - either just filled with something, or empty (nothing inside)
   - [x] Reader - store a state in a reader monad and refer to it only when you need it later on.
   - [x] Writer - Keep a log of the things that happened alongside your computations.
    - [x] A Custom Behaviour you can expand upon yourself, with your own log-appending mechanism.
    - [x] IOListWriter, which logs using an IOList (an implementation of the writer behaviour that is useful in most common circumstances).
   - [x] Sum - Combine any Mappable filled with numbers by summing them.
   - [x] Product - Combine any Mappable filled with numbers by multiplying them.
   - [x] Any - Combine any Mappable filled with booleans by checking if some property is true for at least one of them.
   - [x] All - Combine any Mappable filled with booleans by checking if some property is true for all of them.
   - [ ] Either - Contains two results, returns the first result that is not empty.
- [ ] Fully write this readme.
- [ ] Extend documentation.
  - [ ] More Fruit Salad explanations.
- [ ] Write as many tests as possible.
- [ ] Revisit+extend code examples.



## Installation

If [available in Hex](https://hex.pm/docs/publish) (not yet!), the package can be installed as:

Add `fun_land` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:fun_land, "~> 0.1.0"}]
    end
    ```

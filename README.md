# FunLand

FunLand adds Behaviours to define [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type) ('Container' data types) to Elixir, including many helpful operations with them. Where applicable, an ADT implementation for Elixir's built-in types like Lists, Maps, Strings and Functions are included.

Also included are some implementations of commonly-used ADTs, for your leisure. _(These might be split off in their own library in the future)_

FunLand is based on ideas of the [Fantasy Land](https://github.com/fantasyland/fantasy-land) JavaScript specification for Algebraic Data Types, as well as the implementations of ADTs in other languages, such as [Haskell](haskell.org) and [Idris](http://idris-lang.org/). 

FunLand attempts to use understandable names for the different behaviours and functions, to make ADTs as approachable to newcomers as possible.

### Pre-release version

As can be seen below in the roadmap, FunLand is not fully finished yet.

Mostly lacking are:

- Better documentation
- Implementation of Traversable. _(I still have trouble understanding this thing myself)_
- Tests for most of the example implementations.

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
  - [x] *Reducable* - Any structure that can be `reduce`d to a single value, when given a Combinable (or alternatively, a starting value and a function to combine this with a single value inside the structure). 
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
   - [x] Either/Result - Contains two results, returns the first result of the two that is not empty.
   - [ ] a simple BinaryTree to show how to manipulate these instead of lists.
- [ ] Fully write this readme.
- [ ] Extend documentation.
  - [ ] More Fruit Salad explanations.
- [ ] Write as many tests as possible.
- [ ] Revisit+extend code examples.



## Installation

The package is available on [hex](https://hex.pm/packages/fun_land) and can can be specified as a dependency by adding the snippet below in your `mix.exs`.

```elixir
def deps do
  [{:fun_land, "~> 0.6.1"}]
end
```

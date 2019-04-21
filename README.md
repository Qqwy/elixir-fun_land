# FunLand

[![hex.pm version](https://img.shields.io/hexpm/v/fun_land.svg)](https://hex.pm/packages/fun_land)
[![Build Status](https://travis-ci.org/Qqwy/elixir_fun_land.svg?branch=master)](https://travis-ci.org/Qqwy/elixir_fun_land)

FunLand adds Behaviours to define [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type) ('Container' data types) to Elixir, including many helpful operations with them. Where applicable, an ADT implementation for Elixir's built-in types like Lists, Maps, Strings and Functions are included.

Also included are some implementations of commonly-used ADTs, for your leisure. _(These might be split off in their own library in the future)_

FunLand is based on ideas of the [Fantasy Land](https://github.com/fantasyland/fantasy-land) JavaScript specification for Algebraic Data Types, as well as the implementations of ADTs in other languages, such as [Haskell](haskell.org) and [Idris](http://idris-lang.org/). 

FunLand attempts to use understandable names for the different behaviours and functions, to make ADTs as approachable to newcomers as possible.

### Pre-release version

As can be seen below in the roadmap, FunLand is not fully finished yet. New pre-release versions might introduce backwards-incompatible changes.

Mostly lacking are:

- Enough documentation.
- Tests for most of the example implementations in `FunLand.Builtin.*`.

### Changelog

- 0.9.3 - Fixes bug that made it impossible to compile on Elixir 1.8.x
- 0.9.2 - Numbers v5.0.0 support
- 0.9.1 - Fixes dispatching of Builtin Structs to proper behaviour implementation modules. Adds Combinable and Reducable implementations for MapSet.
- 0.9.0 - Split off FunLandic to its own library.
- 0.8.0 - Important (backwards-incompatible) naming and functionality changes. Implementation of Traversable. Implementations for the SuccessTuple type.

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
  - [x] Traversable
    - [x] Find out how to implement Traversable.traverse properly in a dynamically typed language. (How do you know what empty structure to return when being passed an empty structure?) -> Pass explicit extra parameter with result module.
- [x] Also, where to put these practical implementations? -> FunLandic.*
- [x] How to write proper code for the built-in types like List? (What to put in the monadic syntax? etc.)
- [ ] Catcheable exceptions instead of raised strings.
- [x] Implement some practical Algebraic Data Types to show what can be done with them:
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
   - [x] SuccessTuple implementation of Either/Maybe! Wow!
   - [ ] Fully write this readme.
- [ ] Extend documentation.
  - [ ] More Fruit Salad explanations.
- [ ] Write as many tests as possible.
- [ ] Revisit+extend code examples.

### Later Future:

- [ ] Comonad
- [ ] Improve documentation, better fruit salad descriptions?


## Installation

The package is available on [hex](https://hex.pm/packages/fun_land) and can can be specified as a dependency by adding the snippet below in your `mix.exs`.

```elixir
def deps do
  [{:fun_land, "~> 0.9.2"}]
end
```

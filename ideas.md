
Semicombinable AKA Semigroup 'things that can be combined, but can never be empty'
  -> combine(a, b) :: c, when a, b and c are part of the same semigroup.
    - needs to be associative `(a ++ b) ++ c === a ++ (b ++ c)` where `++` is `combine`.
  Examples: 
    -Positive integer addition, (`combine` = `+`)
    -non-empty lists. (`combine` = `++`)

Combinable AKA Monoid <- Semigroup 'things that can be combined, and can be empty'
  -> empty() :: c, when c is a monoid
    - needs to follow right identity: `combine(a, empty()) == a`
    - needs to follow left identity: `combine(empty(), a) == a`
  examples: 
  integer addition, (`combine` = `+`, `empty` = `0`)
  integer multiplication, (`combine` = `*`, `empty` = `1`)
  lists. (`combine` = `++`, `empty` = `[]`)
  This now is 1:1 with Elixir.Collectable.
  --> give 'free' Elixir.Collectable implementation when someone implements the Monoid behaviourtocol.

--------------

Mappable 'things that can be mapped over (things that can have their contents transformed without transforming their structure)'
  -> map(a, function) :: b when a: mappable{any}, b: mappable{any}
    - needs to follow identity: `map(a, fn x -> x end) == a`
    - needs to follow composition: `map(map(a, f), g) == map(a, fn x -> g(f(x)) end)`
  AKA Functors
  'map' is an implementation that transforms all elements 'a' in Mappable(a) (if any) into `b`'s. The final output will be a Mappable(b).
  Examples: 
    - binary trees: `map` could be defined pre-order or post-order, doesn't matter.
    - lists: `map` could loop through elements one-by-one, or split lists in one-element sections and get each result in parallel.
  Different from Enum.map because:
    - divide-and-conquer instead of fold
    - does not change container format.

Appliable AKA Apply <- Mappable 'things that can be combined when you have two, where the first's contents contains instructions on how to combine with the second's contents.'
  -> apply(a, b) :: c, when a: apply{function}, b: apply{any}, c: apply{any}
  Explanation:
    - When you have a Mappable containing (zero or more) functions, and you want to use these on another Mappable, you're out of luck.
    - When you define `apply` for them, you specify how to combine functions inside one of them with the value(s) in the other.
  Examples:
    - Maybe, Lists (both concatenation or cartesian-product)


Applicative <- Apply 'things that can be wrapped around something, without having to have a wrapper first.'
  - of(any) :: applicative
  Explanation:
    - Wraps a value into an applicative, for later use with `Mappable.map` or `Apply.apply`.


Chainable 'things that can take functions that have a simple value as input and a new Chainable of the same kind as output, and pass their own contents to this function to create a new Chainable. You can chain these together after another.'

Monad 'things that are both applicative and chainable. This means that you can wrap anything in a Monad, then chain zero or more things on it, and finally end up with some desired result.'

_____

Foldable 'things that can be reduced to a single value, when given a function and a starting accumulator value.'

Traversable 'things that are both Mappable and Foldable can be traversed over. This traversion collects results, without modifying the original thing's structure.'


_______________

Idea of implementation:

- Behaviours
- use them using `use`.
- Higher-abstraction behaviours will also import lower-abstraction behaviours which look for lower-abstraction callbacks.
- Whenever possible, overridable implementation of lower-order callbacks is auto-added.
- The behaviours work on structs.
- There is no way to check if the required laws hold true. Depend on correctness of implementation.



# Htaut #

[![travis build][travis shield]][travis link]
[![hackage version][hackage shield][hackage link]]

[travis shield]: https://travis-ci.org/Ailrun/Htaut.svg
[travis link]: https://travis-ci.org/Ailrun/Htaut
[hackage version]: https://img.shields.io/hackage/v/htaut.svg?maxAge=2592000
[hackage link]: http://hackage.haskell.org/package/htaut

**Haskell integrated** TAUtology prover in Type level.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
## Table of Contents ##

- [Htaut](#htaut)
    - [Description](#description)
    - [Current Support](#current-support)
    - [TODO](#todo)
    - [Future Work](#future-work)
    - [Author](#author)

<!-- markdown-toc end -->

## Description ##

This library is tautology prover, i.e. logic prover with qualitifiers. You can prove theorem like `q -> (p -> q)` or ``(p <-> q) <-> ((p <-> r) <-> (q <-> r))``

For example,

``` haskell
conditionAdd :: (Prop p, Prop q) => Prove (q -> (p -> q))
conditionAdd = Evidence (\q p -> q)
```

### Simple Proof ##

With **htaut**, simpliest way for proving of a theorem is providing an evidence (example) of the theorem.

```haskell
syllogism :: (Prop p, Prop q, Prop r) => Prove ((p -> q) -> ((q -> r) -> (p -> r)))
syllogism = Evidence (\pq qr -> qr . pq)
```

Since **htaut** is integrated in haskell, you can use any haskell functions as evidence, and other haskell supports, like lambda, section, etc.

### Little Complex Proof ##

However, 'Evidence from start' approach has a few reusability, so **htaut** provide more elegant, so called monad. In **htaut**, `Prove` type is a monad itself.

```haskell
weirdTheorem :: (Prop p, Prop q, Prop r) =>
                Prove ((p <-> q) -> ((p -> r) <-> (q -> r)))
weirdTheorem = do
  qp <- bicondToLeft -- Preproved theorem
  -- bicondToLeft :: Prove ((p <-> q) -> (q -> p)))
  -- qp :: (p <-> q) -> (q -> p)
  let right c = (. qp c)
  -- right :: (p <-> q) -> ((p -> r) -> (q -> r))

  pq <- bicondToRight  -- Preproved theorem
  -- bicondToRight :: Prove ((p <-> q) -> (p -> q))
  -- pq :: (p <-> q) -> (p -> q)
  let left c = (. pq c)
  -- left :: (p <-> q) -> ((q -> r) -> (p -> r))

  return (\c -> left c `And` right c)
```

Of course, you can summarize this using 'Evidence from start'. and it's shorter than above one.

```Haskell
weirdTheorem :: (Prop p, Prop q, Prop r) =>
                Prove ((p <-> q) -> ((p -> r) <-> (q -> r)))
weirdTheorem = do
  qp <- bicondToLeft -- Preproved theorem
  let right c = (. qp c)

  pq <- bicondToRight  -- Preproved theorem
  let left c = (. pq c)

  return (\c -> left c `And` right c)  

weirdTheorem' :: (Prop p, Prop q, Prop r) =>
                 Prove ((p <-> q) -> ((p -> r) <-> (q -> r)))
weirdTheorem' = Evidence (\(pq `And` qp) -> (. qp) `And` (. pq))
```

However, second way is hard to understand with much complex theorems.

### Special Functions for Complex Proof ###

TBA

## Current Support ##

- Basics are defined.
- You can add more type as instance of type class `Prop`
- If you want, you can prove new theorems one by one with `exfalso`. (but it will terrible since you must bother proving from the basic lemmas.)

## TODO ##

- Support (more) lemmas (Will support all available tautologic lemmas in Benson Mates' _Elementary Logic_).
- Support keywords for (more) efficient proving.

## Future Work ##

- Add automatic proving tools
- ?Add qualitifiers?

## Author ##

Junyoung Clare Jang @ SNU  
- [Github][Github] (@Ailrun)
- [Blog][Blog]

[Github]: https://github.com/Ailrun
[Blog]: https://ailrun.github.io/

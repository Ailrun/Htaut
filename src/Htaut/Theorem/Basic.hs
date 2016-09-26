{-# LANGUAGE TypeOperators #-}
module Htaut.Theorem.Basic where

import Htaut.Proposition
import Htaut.Proving

import Htaut.Theorem.Elementary

-- Principle of Syllogism (1., 2.)
syllogism :: (Prop p, Prop q, Prop r) =>
             Prove ((p -> q) -> ((q -> r) -> (p -> r)))
syllogism = return (flip (.))

syllogism' :: (Prop p, Prop q, Prop r) =>
              Prove ((q -> r) -> ((p -> q) -> (p -> r)))
syllogism' = return (.)

-- Truth Propagation (3.)
propagate :: (Prop p, Prop q) => Prove (p -> ((p -> q) -> q))
propagate = return (flip ($))

-- Condition Modification (4., 5.)
conditionSeperate :: (Prop p, Prop q, Prop r) =>
                     Prove ((p -> (q -> r)) -> ((p -> q) -> (p -> r)))
conditionSeperate = return (\pqr pq p -> pqr p (pq p))

conditionCommute :: (Prop p, Prop q, Prop r) =>
                    Prove ((p -> (q -> r)) -> (q -> (p -> r)))
conditionCommute = return flip

-- Law of Identity (6.)
identity :: (Prop p) => Prove (p -> p)
identity = return id

-- Condition Addition (7.)
conditionAdd :: (Prop p, Prop q) => Prove (q -> (p -> q))
conditionAdd = return const

-- Law of Duns Scotus (8., 9.)
dunsScotus :: (Prop p, Prop q) => Prove (Neg p -> (p -> q))
dunsScotus = return (bottomImply .)

dunsScotus' :: (Prop p, Prop q) => Prove (p -> (Neg p -> Neg q))
dunsScotus' = return (flip (bottomImply .))

-- -- Double Negation (10.)
-- doubleNegate :: (Prop p) => Prove (Neg (Neg p) -> p)
-- doubleNegate = undefined

-- -- Contrapositions
-- contraposition :: (Prop p, Prop q) => Prove ((Neg q -> Neg p) -> (p -> q))
-- contraposition = undefined

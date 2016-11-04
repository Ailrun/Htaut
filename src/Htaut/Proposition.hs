-- |
-- Module      : Htaut.Proposition
-- Description :
-- Copyright   : (c) Junyoung Clare Jang, 2016-
-- License     : see LICENSE
-- Maintainer  : Junyoung Clare Jang <jjc9310@gmail.com>
-- Portability : Windows, POSIX
--
-- Proposition types and typeclasses, and instances.
--
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
module Htaut.Proposition
  (
    Top(..),
    Bottom,
    Neg,
    And(..),
    Or,
    Prop(..),
    SafeProp(..),
    UnsafeProp(..),
    type (<->)
  )
where


-- | The class of propositions.
--
class Prop a

-- | The class of safe propositions.
-- Using these propositions to convert functions is safe.
--
class (Prop a) => SafeProp a

-- | The class of unsafe propositions.
-- Using these propositions to convert functions is unsafe.
-- In the other words, those conversion may lost characteristics of functions.
--
class (Prop a) => UnsafeProp a where
  bottomImply :: Bottom -> a


-- Top and Bottom
-- | The types for top proposition,
-- proposition that is always true.
--
data Top = Top
instance Prop Top
instance UnsafeProp Top where
  bottomImply _ = Top

-- | The types for bottom proposition,
-- proposition that is always false.
--
data Bottom
instance Prop Bottom
instance UnsafeProp Bottom where
  bottomImply f = f

-- Negations
-- | The types for negations of propositions.
--
type Neg a = a -> Bottom

-- Implications
-- | There is no types for implications between propositions,
-- since there is already (->).
--
instance (Prop a, Prop b) => Prop (a -> b)
instance (Prop a, SafeProp b) => SafeProp (a -> b)
instance (Prop a, UnsafeProp b) => UnsafeProp (a -> b) where
  bottomImply f = const (bottomImply f)

-- Conjunctions
-- | The types for conjunctions of propositions.
-- Conjunctions are true if and only if
-- all of its subpropositions are true.
--
data a `And` b = a `And` b
instance (Prop a, Prop b) => Prop (a `And` b)
instance (SafeProp a, SafeProp b) => SafeProp (a `And` b)
instance (UnsafeProp a, UnsafeProp b) => UnsafeProp (a `And` b) where
  bottomImply f = bottomImply f `And` bottomImply f

-- Disjunctions
-- | The types for disjunctions of propositions
-- Disjunctions are true if and only if
-- any of its subpropositions is true.
--
type Or a b = Either a b
instance (Prop a, Prop b) => Prop (a `Or` b)
instance (SafeProp a, SafeProp b) => SafeProp (a `Or` b)
instance (UnsafeProp a, UnsafeProp b) => UnsafeProp (a `Or` b) where
  bottomImply = Left . bottomImply

-- Biconditionals
-- | The types for biconditionals of propositions
-- Biconditionals are true if and only if
-- truth value of its subpropositions are same.
--
type a <-> b = (b -> a) `And` (a -> b)

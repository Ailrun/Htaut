-- |
-- Module : Htaut.Proposition
-- Copyright : (c) Junyoung Clare Jang, 2016-
-- Licenses : see LICENSE
-- Maintainer : Junyoung Clare Jang <jjc9310@gmail.com>
--
-- Proposition types and typeclasses
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

-- | The Class of propositions.
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
data Top = Top
instance Prop Top
instance UnsafeProp Top where
  bottomImply _ = Top

data Bottom
instance Prop Bottom
instance UnsafeProp Bottom where
  bottomImply f = f

-- Negations
type Neg a = a -> Bottom

-- Implications
instance (Prop a, Prop b) => Prop (a -> b)
instance (Prop a, SafeProp b) => SafeProp (a -> b)
instance (Prop a, UnsafeProp b) => UnsafeProp (a -> b) where
  bottomImply f = const (bottomImply f)

-- Conjunctions
data a `And` b = a `And` b
instance (Prop a, Prop b) => Prop (a `And` b)
instance (SafeProp a, SafeProp b) => SafeProp (a `And` b)
instance (UnsafeProp a, UnsafeProp b) => UnsafeProp (a `And` b) where
  bottomImply f = bottomImply f `And` bottomImply f

-- Disjunctions
type Or a b = Either a b
instance (Prop a, Prop b) => Prop (a `Or` b)
instance (SafeProp a, SafeProp b) => SafeProp (a `Or` b)
instance (UnsafeProp a, UnsafeProp b) => UnsafeProp (a `Or` b) where
  bottomImply = Left . bottomImply

-- Biconditionals
type a <-> b = (b -> a) `And` (a -> b)

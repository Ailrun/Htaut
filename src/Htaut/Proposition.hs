{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
module Htaut.Proposition
  (
    Top(..),
    Bottom(..),
    Neg(..),
    And(..),
    Or(..),
    type (<->),
    Prop(..)
  )
where


class Prop a where
  bottomImply :: Bottom -> a


-- Top and Bottom
data Top = Top
instance Prop Top where
  bottomImply _ = Top

data Bottom
instance Prop Bottom where
  bottomImply f = f

-- Negations
type Neg a = a -> Bottom
  
-- Implications
instance (Prop a, Prop b) => Prop (a -> b) where
  bottomImply f = const (bottomImply f)

-- Conjunctions
data a `And` b = a `And` b
instance (Prop a, Prop b) => Prop (a `And` b) where
  bottomImply f = bottomImply f `And` bottomImply f

-- Disjunctions
type Or a b = Either a b
instance (Prop a, Prop b) => Prop (a `Or` b) where
  bottomImply = Left . bottomImply

-- Biconditionals
type a <-> b = (a -> b) `And` (b -> a)

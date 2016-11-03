module Htaut.Proving
  (
    Prove(..)
  )
where

import Htaut.Proposition

data Prove a = Evidence a

instance Functor Prove where
  fmap f (Evidence x) = Evidence (f x)
instance Applicative Prove where
  pure = Evidence
  Evidence f <*> Evidence x = Evidence (f x)
instance Monad Prove where
  return = pure
  Evidence a >>= f = f a

-- |
-- Module      : Htaut.Proving
-- Description :
-- Copyright   : (c) Junyoung Clare Jang, 2016-
-- License     : see LICENSE
-- Maintainer  : Junyoung Clare Jang <jjc9310@gmail.com>
-- Portability : Windows, POSIX
--
-- Proof types and instances.
--
module Htaut.Proving
  (
    Prove(..)
  )
where

-- | The type for proving
data Prove a = Evidence {useEvidence :: a}

instance Functor Prove where
  fmap f (Evidence x) = Evidence (f x)
instance Applicative Prove where
  pure = Evidence
  Evidence f <*> Evidence x = Evidence (f x)
instance Monad Prove where
  return = pure
  Evidence a >>= f = f a

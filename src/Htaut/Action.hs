-- |
-- Module      : Htaut.Action
-- Description :
-- Copyright   : (c) Junyoung Clare Jang, 2016-
-- License     : see LICENSE
-- Maintainer  : Junyoung Clare Jang <jjc9310@gmail.com>
-- Portability : Windows, POSIX
--
-- Actions for proof.
--
module Htaut.Action
  (
    premiseFrom,
    premiseTo
  )
where

import Htaut.Proposition (Prop)
import Htaut.Proving (Prove(..))


-- | Function for generate premise
--
premiseFrom :: (Prop a, Prop b) => Prove (a -> b) -> a -> Prove b
premiseFrom (Evidence ab) = \a -> Evidence (ab a)

-- | Function for consuming premise
--
premiseTo :: (Prop a, Prop b) => (a -> Prove b) -> Prove (a -> b)
premiseTo ap = Evidence (\a -> useEvidence $ ap a)

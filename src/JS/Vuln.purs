module JS.Vuln
  ( vulnPkgs
  ) where

import Data.Set (Set, fromFoldable)

foreign import vulnPkgArray :: Array String

-- A Set containing the list of packages which contain critical unfixed vulnerabilities
vulnPkgs :: Set String
vulnPkgs = fromFoldable vulnPkgArray

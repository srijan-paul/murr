module JS.Vuln
  ( vulnPkgs
  )
  where

import Data.Set (Set, fromFoldable)
import JS.VulnPkg (vulnPkgArray)

vulnPkgs :: Set String
vulnPkgs = fromFoldable vulnPkgArray

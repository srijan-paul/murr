module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import JS.Vuln (vulnPkgs)
import Data.Set (member)

main :: Effect Unit
main = do
  log $ show $ member "arrayfire-js" vulnPkgs 

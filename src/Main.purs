module Main where

import Data.Set (member)
import Effect (Effect)
import Effect.Console (log)
import JS.Vuln (vulnPkgs)
import Murr.Core (parsePackageJson)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Prelude (Unit, (=<<), ($), discard, show)

main :: Effect Unit
main = do
  log $ show $ member "arrayfire-js" vulnPkgs
  let contents = readTextFile UTF8 "package.json"
  log =<< contents
  log $ show $ parsePackageJson contents

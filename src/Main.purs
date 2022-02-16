module Main where

import Data.Either (Either(..))
import Data.Traversable (for_)
import Effect (Effect)
import Effect.Class.Console (error)
import Effect.Console (log)
import Murr.Core (getVulnJSPkgs, parsePackageJson)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Prelude (Unit, discard, bind, (<$>))

main :: Effect Unit
main = do
  -- log $ show $ member "arrayfire-js" vulnPkgs
  contents <- readTextFile UTF8 "package.json"
  log contents
  let
    packageJson = parsePackageJson contents
    vuln = getVulnJSPkgs <$> packageJson
  case vuln of
    Left errMsg -> error errMsg
    Right xs -> for_ xs log

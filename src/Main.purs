module Main where

import Data.Maybe

import Data.Either (Either(..))
import Data.Traversable (for_, traverse)
import Effect (Effect)
import Effect.Class.Console (error)
import Effect.Console (log)
import Foreign.Object as FO
import Murr.Core (getVulnJSPkgs, parsePackageJson)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Prelude (Unit, discard, show, bind, (<$>), pure, unit, (<<<))

main :: Effect Unit
main = do
  -- log $ show $ member "arrayfire-js" vulnPkgs
  contents <- readTextFile UTF8 "package.json"
  log contents
  let
    packageJson = parsePackageJson contents
    vuln = getVulnJSPkgs <$> packageJson
  case vuln of
    Left errMsg -> log errMsg
    Right xs -> for_ xs log

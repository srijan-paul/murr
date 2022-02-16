module Main where

import Data.Either (Either(..))
import Data.List
import Data.Traversable (for_)
import Effect (Effect)
import Effect.Class.Console (error)
import Effect.Console (log)
import Murr.Core (getVulnJSPkgs, parsePackageJson)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Process (cwd)
import Node.Path as Path
import Prelude (Unit, discard, bind, (<$>), ($), (<>), (<<<), show)

-- Helper function for coloring the console output
txt :: Int -> Int -> String -> String
txt start end s = "\x1b[" <> (show start) <> "m" <> s <> "\x1b[" <> (show end) <> "m"

logVulnPkgs :: List String -> Effect Unit
logVulnPkgs Nil = do
  log $ txt 32 39 "[MURR] No vulnerable packages found. Good work!"

logVulnPkgs pkgs = do
  log $ txt 31 39 "[MURR] Vulnerable packages detected! Consider replacing these packages:"
  for_ pkgs $ (log <<< formatPkgName)
  where
  formatPkgName = ("       " <> _)

main :: Effect Unit
main = do
  currentDir <- cwd
  let
    packageJsonPath = Path.concat [ currentDir, "package.json" ]
  contents <- readTextFile UTF8 packageJsonPath
  let
    packageJson = parsePackageJson contents
    vuln = getVulnJSPkgs <$> packageJson
  case vuln of
    Left errMsg -> error errMsg
    Right xs -> logVulnPkgs xs

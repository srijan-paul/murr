module Main where


import Data.Traversable (for_)
import Effect (Effect)
import Effect.Console (log)
import Murr.Core (inspectProject)
import Node.Process (cwd)
import Prelude (Unit, discard, bind, ($), (<>), (<<<), show)

-- Helper function for coloring the console output
txt :: Int -> Int -> String -> String
txt start end s = "\x1b[" <> (show start) <> "m" <> s <> "\x1b[" <> (show end) <> "m"

logVulnPkgs :: Array String -> Effect Unit
logVulnPkgs [] = do
  log $ txt 32 39 "[MURR] No vulnerable packages found. Good work!"

logVulnPkgs pkgs = do
  log $ txt 31 39 "[MURR] Vulnerable packages detected! Consider replacing these packages:"
  for_ pkgs $ (log <<< formatPkgName)
  where
  formatPkgName = ("       " <> _)

main :: Effect Unit
main = do
  currentDir <- cwd
  vuln <- inspectProject currentDir
  logVulnPkgs vuln

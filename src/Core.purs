module Murr.Core (parsePackageJson, getVulnJSPkgs) where

import Data.List

import Data.Argonaut as A
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Data.Set (member)
import Foreign.Object as FO
import JS.Vuln as JS
import Prelude (identity, (<$>), (<<<), ($))

parsePackageJson :: String -> Either String (FO.Object A.Json)
parsePackageJson str =
  let
    parseResult = A.jsonParser str

    getObject =
      A.caseJsonObject
        FO.empty
        identity
  in
    getObject <$> parseResult

-- If the argument is a JSON object, then returns a list containing its keys.
-- Otherwise returns an empty list
getKeys :: A.Json -> List String
getKeys = A.caseJsonObject Nil (fromFoldable <<< FO.keys)

justOrDefault :: forall a. a -> Maybe a -> a
justOrDefault _ (Just x) = x
justOrDefault d Nothing = d

-- Takes a JSON Object representing a project's package.json and returns
-- the list of vulnerable packages
getVulnJSPkgs :: (FO.Object A.Json) -> (List String)
getVulnJSPkgs pkgJson =
  let
    getDeps name = justOrDefault Nil $ getKeys <$> FO.lookup name pkgJson
    devDeps = getDeps "devDependencies" 
    deps = getDeps "dependencies" 
    isDepVuln depName = member depName JS.vulnPkgs
    vulnDevDeps = filter isDepVuln devDeps
    vulnDeps = filter isDepVuln deps
  in
    concat $ vulnDevDeps : vulnDeps : Nil

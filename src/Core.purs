module Murr.Core
  ( getVulnPkgList
  , getVulnerablePackages
  , inspectPackageJson
  , inspectProject
  , parsePackageJson
  ) where

import Data.List
import Data.Argonaut as A
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Set (member)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Effect.Exception (throw)
import Foreign.Object as FO
import JS.Vuln as JS
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Path as Path
import Prelude (identity, (<$>), (<<<), ($), bind, pure)

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
getVulnPkgList :: (FO.Object A.Json) -> (List String)
getVulnPkgList pkgJson =
  let
    getDeps name = justOrDefault Nil (getKeys <$> FO.lookup name pkgJson)

    devDeps = getDeps "devDependencies"
    deps = getDeps "dependencies"

    isDepVuln depName = member depName JS.vulnPkgs

    vulnDevDeps = filter isDepVuln devDeps
    vulnDeps = filter isDepVuln deps
  in
    concat $ vulnDevDeps : vulnDeps : Nil

getVulnerablePackages :: (FO.Object A.Json) -> (Array String)
getVulnerablePackages = Array.fromFoldable <<< getVulnPkgList

error :: forall a. String -> a
error = unsafePerformEffect <<< throw

inspectPackageJson :: String -> Array String
inspectPackageJson pkgContents =
  let
    packageJson = parsePackageJson pkgContents
    vuln = getVulnerablePackages <$> packageJson
  in
    case vuln of
      Left errMsg -> error errMsg
      Right xs -> xs

inspectProject :: String -> Effect (Array String)
inspectProject projectPath = do
  let
    packageJsonPath = Path.concat [ projectPath, "package.json" ]
  contents <- readTextFile UTF8 packageJsonPath
  pure $ inspectPackageJson contents

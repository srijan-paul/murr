module Murr.Core (parsePackageJson) where

import Data.Either
import Data.Argonaut as A
import Foreign.Object as FO
import Prelude (identity, (<$>))

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

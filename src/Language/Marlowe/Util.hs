{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-orphans #-}
module Language.Marlowe.Util where
import           Data.List                  (foldl')
import           Data.Map.Strict            (Map)
import qualified Data.Map.Strict            as Map
import           Data.String
import qualified Data.Text                  as T

import           Language.Marlowe.Semantics

instance IsString PubKey where
    fromString s = PubKey (T.pack s)

instance IsString ValueId where
    fromString s = ValueId (T.pack s)

alicePubKey :: PubKey
alicePubKey = PubKey "Alice"

aliceAcc :: Party
aliceAcc = alicePubKey

bobPubKey :: PubKey
bobPubKey = PubKey "Bob"

bobAcc :: Party
bobAcc = bobPubKey

carolPubKey :: PubKey
carolPubKey = PubKey "Carol"

carolAcc :: Party
carolAcc = carolPubKey

charliePubKey :: PubKey
charliePubKey = PubKey "Charlie"

charlieAcc :: Party
charlieAcc = charliePubKey

evePubKey :: PubKey
evePubKey = PubKey "Eve"

eveAcc :: Party
eveAcc = evePubKey


type AccountsDiff = Map Party Money


emptyAccountsDiff :: AccountsDiff
emptyAccountsDiff = Map.empty


isEmptyAccountsDiff :: AccountsDiff -> Bool
isEmptyAccountsDiff = all (== Lovelace 0)


-- Adds a value to the map of outcomes
addAccountsDiff :: Party -> Money -> AccountsDiff -> AccountsDiff
addAccountsDiff party diffValue trOut = let
    newValue = case Map.lookup party trOut of
        Just value -> value + diffValue
        Nothing    -> diffValue
    in Map.insert party newValue trOut


-- | Extract total outcomes from transaction inputs and outputs
getAccountsDiff :: [Payment] -> [Input] -> AccountsDiff
getAccountsDiff payments inputs =
    foldl' (\acc (p, m) -> addAccountsDiff p m acc) emptyAccountsDiff (incomes ++ outcomes)
  where
    incomes  = [ (p,  m) | IDeposit _ p m <- inputs ]
    outcomes = [ (p, -m) | Payment p m  <- payments ]


module Msgs exposing (..)

import Http
import Models exposing (Image)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchImages (WebData (List Image))
    | OnLocationChange Location

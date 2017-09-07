module Msgs exposing (..)

import Http
import Models exposing (Image, Sorting)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchImages (WebData (List Image))
    | OnLocationChange Location
    | OnChangeSorting Sorting
    | OnInputDeviceSearch String

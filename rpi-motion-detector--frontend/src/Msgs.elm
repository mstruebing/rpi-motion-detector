module Msgs exposing (..)

import Models exposing (Image, Sorting)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Time exposing (Time)


type Msg
    = OnFetchImages (WebData (List Image))
    | OnTryToUpdateImages Time
    | OnUpdateImages (WebData (List Image))
    | OnLocationChange Location
    | OnChangeSorting Sorting
    | OnInputDeviceSearch String
    | OnTime Time

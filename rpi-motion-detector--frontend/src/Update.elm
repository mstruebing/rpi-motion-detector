module Update exposing (..)

import Models exposing (Image, Model)
import Msgs exposing (Msg(..))
import RemoteData
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchImages response ->
            ( { model | images = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        Msgs.OnChangeSorting sorting ->
            ( { model | timeSorting = sorting }, Cmd.none )

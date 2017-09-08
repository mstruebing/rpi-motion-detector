module Update exposing (..)

import Commands exposing (fetchImages, updateImages)
import Models exposing (Image, Model)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchImages response ->
            ( { model | images = response }, Cmd.none )

        Msgs.OnTryToUpdateImages time ->
            ( { model | lastUpdate = time }, updateImages )

        Msgs.OnUpdateImages response ->
            ( { model | newImages = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        Msgs.OnChangeSorting sorting ->
            ( { model | timeSorting = sorting }, Cmd.none )

        Msgs.OnInputDeviceSearch input ->
            ( { model | deviceSearch = input }, Cmd.none )

        Msgs.OnTime time ->
            ( { model | lastUpdate = time }, Cmd.none )

        Msgs.FetchImages ->
            ( model, fetchImages )

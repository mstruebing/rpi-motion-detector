module View exposing (..)

import Html exposing (Html, div, text)
import Images.List
import Models exposing (ImagePath, Model)
import Msgs exposing (Msg)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.ImagesRoute ->
            Images.List.view model.images model.timeSorting model.deviceSearch model.lastUpdate model.newImages

        Models.NotFoundRoute ->
            notFoundView

        _ ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found"
        ]

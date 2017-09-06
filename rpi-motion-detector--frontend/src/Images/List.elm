module Images.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, height, href, src, target, width)
import Models exposing (Image)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)


view : WebData (List Image) -> Html Msg
view response =
    div []
        [ nav
        , maybeList response
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Images" ] ]


list : List Image -> Html Msg
list images =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Path" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Timestamp" ]
                    , th [] [ text "Preview" ]
                    ]
                ]
            , tbody [] (List.map imageRow (List.sortBy .timestamp images))
            ]
        ]


imageRow : Image -> Html Msg
imageRow image =
    tr []
        [ td [] [ text image.path ]
        , td [] [ text image.name ]
        , td [] [ text (toString image.timestamp) ]
        , td []
            [ a
                [ href image.path, target "_blank" ]
                [ img [ src image.path, width 200, height 200 ] [] ]
            ]
        ]


maybeList : WebData (List Image) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success images ->
            list images

        RemoteData.Failure error ->
            text (toString error)

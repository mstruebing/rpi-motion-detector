module Images.List exposing (..)

import Date exposing (Date, day, hour, minute, month, second, year)
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
                    , th [] [ text "Device" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Capture time" ]
                    , th [] [ text "Preview" ]
                    ]
                ]
            , tbody []
                (images
                    |> List.sortBy .timestamp
                    |> List.reverse
                    |> List.map imageRow
                )
            ]
        ]


imageRow : Image -> Html Msg
imageRow image =
    tr []
        [ td [] [ text image.path ]
        , td []
            [ image.name
                |> String.split "_"
                |> List.head
                |> Maybe.withDefault "Unknown Device"
                |> text
            ]
        , td [] [ text image.name ]
        , td []
            [ image.timestamp
                |> makeTimeStringFromTimesamp
                |> text
            ]
        , td []
            [ a
                [ href image.path, target "_blank" ]
                [ img [ src image.path, width 200, height 200 ] [] ]
            ]
        ]


makeTimeStringFromTimesamp : Int -> String
makeTimeStringFromTimesamp timestamp =
    timestamp
        |> (*) 1000
        |> toFloat
        |> Date.fromTime
        |> (\date ->
                toString (Date.hour date)
                    ++ ":"
                    ++ toString (Date.minute date)
                    ++ ":"
                    ++ toString (Date.second date)
                    ++ " on "
                    ++ toString (Date.day date)
                    ++ ". "
                    ++ toString (Date.month date)
                    ++ " "
                    ++ toString (Date.year date)
           )


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

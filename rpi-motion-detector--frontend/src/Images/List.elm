module Images.List exposing (..)

import Date exposing (Date, day, hour, minute, month, second, year)
import Html exposing (..)
import Html.Attributes exposing (class, height, href, placeholder, src, target, width)
import Html.Events exposing (onClick)
import Models exposing (Image, Sorting)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)


view : WebData (List Image) -> Sorting -> Html Msg
view response timeSorting =
    div []
        [ nav
        , maybeList response timeSorting
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Images", search ] ]


search : Html Msg
search =
    div [ class "" ]
        [ input
            [ placeholder "Search Device" ]
            []
        ]


list : List Image -> Sorting -> Html Msg
list images timeSorting =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Path" ]
                    , th [] [ text "Device" ]
                    , th [] [ text "Name" ]
                    , th []
                        [ a [ onClick <| changeSorting timeSorting ]
                            [ text "Capture time "
                            , sortingArrow timeSorting
                            ]
                        ]
                    , th [] [ text "Preview" ]
                    ]
                ]
            , tbody []
                (case timeSorting of
                    Models.Desc ->
                        List.map imageRow (List.reverse (List.sortBy .timestamp images))

                    Models.Asc ->
                        List.map imageRow (List.sortBy .timestamp images)
                )
            ]
        ]


sortingArrow : Sorting -> Html Msg
sortingArrow sorting =
    case sorting of
        Models.Desc ->
            span [ class "fa fa-chevron-up" ] []

        Models.Asc ->
            span [ class "fa fa-chevron-down" ] []


changeSorting : Sorting -> Msg
changeSorting sorting =
    case sorting of
        Models.Asc ->
            Msgs.OnChangeSorting Models.Desc

        Models.Desc ->
            Msgs.OnChangeSorting Models.Asc


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


maybeList : WebData (List Image) -> Sorting -> Html Msg
maybeList response timeSorting =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success images ->
            list images timeSorting

        RemoteData.Failure error ->
            text (toString error)

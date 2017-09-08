module Images.List exposing (..)

import Commands exposing (fetchImages)
import Date exposing (Date, day, hour, minute, month, second, year)
import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, height, href, placeholder, src, target, width)
import Html.Events exposing (onClick, onInput)
import Models exposing (Image, Sorting)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Time exposing (Time)


view : WebData (List Image) -> Sorting -> String -> Time -> WebData (List Image) -> Html Msg
view initialResponse timeSorting filter lastUpdate updateResponse =
    div []
        [ nav lastUpdate
        , maybeNewImages initialResponse updateResponse
        , maybeList initialResponse timeSorting filter
        ]


nav : Time -> Html Msg
nav lastUpdate =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text <| "Last update: " ++ makeLastUpdateString lastUpdate, search ] ]


search : Html Msg
search =
    div [ class "" ] [ input [ onInput Msgs.OnInputDeviceSearch, placeholder "Search Device" ] [] ]


newImagesMessage : Int -> Html Msg
newImagesMessage count =
    if count > 0 then
        div [ onClick Msgs.FetchImages ]
            [ text <| toString count ++ " New Images, reload the page to see them" ]
    else
        text ""


list : List Image -> Sorting -> String -> Html Msg
list images timeSorting filter =
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
            , tbody [] (List.map imageRow (buildTableBody images timeSorting filter))
            ]
        ]


buildTableBody : List Image -> Sorting -> String -> List Image
buildTableBody images timeSorting filter =
    case timeSorting of
        Models.Desc ->
            images
                |> List.filter (\image -> String.contains filter <| extractDeviceName image.name)
                |> List.sortBy .timestamp
                |> List.reverse

        Models.Asc ->
            images
                |> List.filter (\image -> String.contains filter <| extractDeviceName image.name)
                |> List.sortBy .timestamp


sortingArrow : Sorting -> Html Msg
sortingArrow sorting =
    case sorting of
        Models.Asc ->
            span [ class "fa fa-chevron-up" ] []

        Models.Desc ->
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
            [ text <| extractDeviceName image.name
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


makeLastUpdateString : Float -> String
makeLastUpdateString timestamp =
    timestamp
        |> Date.fromTime
        |> (\date ->
                toString (Date.hour date)
                    ++ ":"
                    ++ toString (Date.minute date)
                    ++ ":"
                    ++ toString (Date.second date)
           )


makeTimeStringFromTimesamp : Float -> String
makeTimeStringFromTimesamp timestamp =
    timestamp
        |> (*) 1000
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


extractDeviceName : String -> String
extractDeviceName fileName =
    fileName
        |> String.split "_"
        |> List.head
        |> Maybe.withDefault "Unknown Device"


maybeNewImages : WebData (List Image) -> WebData (List Image) -> Html Msg
maybeNewImages initialResponse updateResponse =
    case initialResponse of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text ""

        RemoteData.Success images ->
            case updateResponse of
                RemoteData.NotAsked ->
                    text ""

                RemoteData.Loading ->
                    text ""

                RemoteData.Success newImages ->
                    newImagesMessage <| (List.length newImages - List.length images)

                RemoteData.Failure error ->
                    text ""

        RemoteData.Failure error ->
            text ""


maybeList : WebData (List Image) -> Sorting -> String -> Html Msg
maybeList response timeSorting filter =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success images ->
            list images timeSorting filter

        RemoteData.Failure error ->
            text (toString error)

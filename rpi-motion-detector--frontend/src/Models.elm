module Models exposing (..)

import RemoteData exposing (WebData)
import Time exposing (Time)


type alias Model =
    { images : WebData (List Image)
    , lastUpdate : Time
    , newImages : WebData (List Image)
    , route : Route
    , timeSorting : Sorting
    , deviceSearch : String
    }


initialModel : Route -> Model
initialModel route =
    { images = RemoteData.Loading
    , newImages = RemoteData.Loading
    , lastUpdate = 0
    , route = route
    , timeSorting = Desc
    , deviceSearch = ""
    }


type Sorting
    = Desc
    | Asc


type alias ImagePath =
    String


type alias Image =
    { name : String
    , path : ImagePath
    , timestamp : Float
    }


type Route
    = ImagesRoute
    | ImageRoute ImagePath
    | NotFoundRoute

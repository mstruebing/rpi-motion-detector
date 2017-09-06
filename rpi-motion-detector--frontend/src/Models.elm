module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { images : WebData (List Image)
    , route : Route
    , timeSorting : Sorting
    }


initialModel : Route -> Model
initialModel route =
    { images = RemoteData.Loading
    , route = route
    , timeSorting = Desc
    }


type Sorting
    = Desc
    | Asc


type alias ImagePath =
    String


type alias Image =
    { name : String
    , path : ImagePath
    , timestamp : Int
    }


type Route
    = ImagesRoute
    | ImageRoute ImagePath
    | NotFoundRoute

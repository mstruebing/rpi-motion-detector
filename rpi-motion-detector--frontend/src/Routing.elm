module Routing exposing (..)

import Models exposing (ImagePath, Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ImagesRoute top
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


imagesPath : String
imagesPath =
    "#images"


imagePath : ImagePath -> String
imagePath id =
    "#images/" ++ id

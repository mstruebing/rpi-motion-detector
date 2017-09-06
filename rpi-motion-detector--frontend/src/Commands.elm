module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Models exposing (Image)
import Msgs exposing (Msg)
import RemoteData


fetchImages : Cmd Msg
fetchImages =
    Http.get fetchImagesUrl imagesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchImages


fetchImagesUrl : String
fetchImagesUrl =
    "http://localhost:4000/images"


imagesDecoder : Decode.Decoder (List Image)
imagesDecoder =
    Decode.list imageDecoder


imageDecoder : Decode.Decoder Image
imageDecoder =
    decode Image
        |> required "name" Decode.string
        |> required "path" Decode.string
        |> required "timestamp" Decode.int

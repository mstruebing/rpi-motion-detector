module Tasks exposing (..)

import Msgs exposing (Msg(..))
import Task exposing (Task)
import Time exposing (Time)


getTime =
    Time.now
        |> Task.perform Msgs.OnTime

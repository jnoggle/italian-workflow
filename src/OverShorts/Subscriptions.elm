module OverShorts.Subscriptions exposing (..)

import Material
import OverShorts.Messages exposing (Msg(..))
import OverShorts.Models exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model

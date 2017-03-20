module GiftCertificates.Subscriptions exposing (..)

import Material
import GiftCertificates.Messages exposing (Msg(..))
import GiftCertificates.Models exposing (Model)


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model

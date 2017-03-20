module Main exposing (..)

import Navigation exposing (Location)
import Material
import Messages exposing (Msg(..))
import Models exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)
import Routing exposing (Route)
import GiftCertificates.Commands exposing (fetchAll)
import GiftCertificates.Subscriptions


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Sub.map GiftCertificateMsg <| GiftCertificates.Subscriptions.subscriptions model.giftCertificates
        ]



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

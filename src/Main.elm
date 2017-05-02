module Main exposing (..)

import Navigation exposing (Location)
import Material
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Route)
import Update exposing (update)
import View exposing (view)
import GiftCertificates.Commands exposing (fetchTodays)
import GiftCertificates.Subscriptions
import GiftCertificates.Models
import GiftCertificates.Init
import OverShorts.Commands exposing (fetchTodays)
import OverShorts.Subscriptions
import OverShorts.Models
import OverShorts.Init


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Routing.parseLocation location

        ( giftCertificatesModel, giftCertificateCmd ) =
            GiftCertificates.Init.init

        ( overShortsModel, overShortCmd ) =
            OverShorts.Init.init

        model =
            { user_id = ""
            , username = ""
            , password = ""
            , token = ""
            , errorMsg = ""
            , giftCertificates = giftCertificatesModel
            , overShorts = overShortsModel
            , route = route
            , mdl = Material.model
            }

        cmds =
            Cmd.batch [ Cmd.map GiftCertificateMsg giftCertificateCmd, Cmd.map OverShortMsg overShortCmd ]
    in
        ( model, cmds )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Sub.map GiftCertificateMsg <| GiftCertificates.Subscriptions.subscriptions model.giftCertificates
        , Sub.map OverShortMsg <| OverShorts.Subscriptions.subscriptions model.overShorts
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

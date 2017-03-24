module Update exposing (..)

import Navigation
import Material
import Messages exposing (Msg(..))
import Models exposing (Model, Field(..))
import Commands exposing (..)
import Routing exposing (parseLocation)
import GiftCertificates.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "The Message" msg of
        LoginFormInput field val ->
            case field of
                Username ->
                    ( { model | username = val }, Cmd.none )

                Password ->
                    ( { model | password = val }, Cmd.none )

        Login ->
            ( model, authUserCmd model loginUrl )

        Logout ->
            ( { model | username = "", token = "" }, Navigation.newUrl "#login" )

        Authorization (Ok newToken) ->
            ( { model | token = newToken, password = "", errorMsg = "" }, Cmd.none )

        Authorization (Err error) ->
            ( { model | errorMsg = (toString error) }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        GiftCertificateMsg subMsg ->
            let
                ( updatedGiftCertificates, cmd ) =
                    GiftCertificates.Update.update subMsg model.giftCertificates
            in
                ( { model | giftCertificates = updatedGiftCertificates }, Cmd.map GiftCertificateMsg cmd )

        GiftCertificates ->
            ( model, Navigation.newUrl "#giftcertificates" )

        Mdl msg_ ->
            Material.update Mdl msg_ model

module Update exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Models exposing (Model, Field(..))
import Commands exposing (..)
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginFormInput field val ->
            case field of
                Username ->
                    ( { model | username = val }, Cmd.none )

                Password ->
                    ( { model | password = val }, Cmd.none )

        Login ->
            ( model, authUserCmd model loginUrl )

        Logout ->
            ( { model | username = "", token = "" }, Cmd.none )

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

        GiftCertificates ->
            ( model, Navigation.newUrl "#giftcertificates" )

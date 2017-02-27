module User.Update exposing (..)

import User.Messages exposing (Msg(..))
import User.Models exposing (User, Field(..))
import Navigation
import User.Commands exposing (..)


update : Msg -> User -> ( User, Cmd Msg )
update msg user =
    case msg of
        FormInput inputId val ->
            case inputId of
                Username ->
                    ( { user | username = val }, Cmd.none )

                Password ->
                    ( { user | password = val }, Cmd.none )

        RegisterUser ->
            ( user, authUserCmd user registerUrl )

        GetTokenSuccess (Ok newToken) ->
            ( { user | token = newToken, password = "", msg = "" }, Cmd.none )

        GetTokenSuccess (Err error) ->
            ( { user | msg = (toString error) }, Cmd.none )

        LogIn ->
            ( user, authUserCmd user loginUrl )

        LogOut ->
            ( { user | username = "", token = "" }, Cmd.none )

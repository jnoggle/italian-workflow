module User.Update exposing (..)

import User.Messages exposing (Msg(..))
import User.Models exposing (User)
import Navigation
import User.Commands exposing (..)


update : Msg -> User -> ( User, Cmd Msg )
update msg user =
    case msg of
        SetUsername username ->
            ( { user | username = username }, Cmd.none )

        SetPassword password ->
            ( { user | password = password }, Cmd.none )

        RegisterUser ->
            ( user, authUserCmd user registerUrl )

        GetTokenSuccess (Ok newToken) ->
            ( { user | token = newToken, password = "", errorMsg = "" }, Cmd.none )

        GetTokenSuccess (Err error) ->
            ( { user | errorMsg = (toString error) }, Cmd.none )

        LogIn ->
            ( user, authUserCmd user loginUrl )

        LogOut ->
            ( { user | username = "", token = "" }, Cmd.none )

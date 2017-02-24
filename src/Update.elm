module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import User.Update
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserMsg subMsg ->
            let
                ( updatedUser, cmd ) =
                    User.Update.update subMsg model.user
            in
                ( { model | user = updatedUser }, Cmd.map UserMsg cmd )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

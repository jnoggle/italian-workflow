module View exposing (..)

import Html exposing (Html, div, text)
import Messages exposing (Msg(..))
import Models exposing (Model)
import User.Login
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        LoginRoute ->
            Html.map UserMsg (User.Login.view model.user)

        GiftCertificatesRoute ->
            giftCertificatesPage model

        NotFoundRoute ->
            notFoundView


giftCertificatesPage : Model -> Html Msg
giftCertificatesPage model =
    div []
        [ text "Not implemented"
        ]


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]

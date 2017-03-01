module View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (Msg(..))
import Models exposing (Model, Field(..))
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        LoginRoute ->
            loginView model

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


loginView : Model -> Html Msg
loginView model =
    let
        loggedIn : Bool
        loggedIn =
            if String.length model.token > 0 then
                True
            else
                False

        authBoxView =
            let
                showError : String
                showError =
                    if String.isEmpty model.errorMsg then
                        "hidden"
                    else
                        ""

                greeting : String
                greeting =
                    "Hello, " ++ model.username ++ "!"
            in
                if loggedIn then
                    div [ id "greeting" ]
                        [ h3 [ class "text-center" ] [ text greeting ]
                        , p [ class "text-center" ] [ text "You are logged in" ]
                        , p [ class "text-center" ]
                            [ button [ class "btn btn-danger", onClick Logout ] [ text "Log Out" ]
                            ]
                        ]
                else
                    div [ id "form" ]
                        [ h2 [ class "text-center" ] [ text "Log in or Register" ]
                        , p [ class "help-block" ] [ text "If you already have an account, please Log In. Otherwise, enter your desired username and password and Register." ]
                        , div [ class showError ]
                            [ div [ class "alert alert-danger" ] [ text model.errorMsg ]
                            ]
                        , div [ class "form-group row" ]
                            [ div [ class "col-md-offset-2 col-md-8" ]
                                [ label [ for "username" ] [ text "Username:" ]
                                , input [ id "username", type_ "text", class "form-control", Html.Attributes.value model.username, onInput (LoginFormInput Username) ] []
                                ]
                            ]
                        , div [ class "form-group row" ]
                            [ div [ class "col-md-offset-2 col-md-8" ]
                                [ label [ for "password" ] [ text "Password:" ]
                                , input [ id "password", type_ "password", class "form-control", Html.Attributes.value model.password, onInput (LoginFormInput Password) ] []
                                ]
                            ]
                        , div [ class "text-center" ]
                            [ button [ class "btn btn-primary", onClick Login ] [ text "Log In" ]
                            , button [ class "btn", onClick GiftCertificates ] [ text "Gift Certificates" ]
                            ]
                        ]
    in
        div [ class "container" ]
            [ h2 [ class "text-center" ] [ text "Spaghetti Workflow" ]
            , div [ class "jumbotron text-left" ]
                [ authBoxView
                ]
            ]

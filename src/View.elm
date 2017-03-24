module View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Icon as Icon
import Material.Color as Color
import Material.Menu as Menu
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Options as Options exposing (css, cs, when)
import Messages exposing (Msg(..))
import Models exposing (Model, Field(..))
import Routing exposing (Route(..))
import GiftCertificates.List


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div []
        [ Options.stylesheet styles
        , Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            , Options.css "display" "flex !important"
            , Options.css "flex-direction" "row"
            , Options.css "align-items" "center"
            ]
            { header = [ viewHeader model ]
            , drawer = [ drawerHeader model, viewDrawer model ]
            , tabs = ( [], [] )
            , main =
                [ viewBody model ]
            }
        ]


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        LoginRoute ->
            loginView model

        GiftCertificatesRoute ->
            Html.map GiftCertificateMsg (GiftCertificates.List.view model.giftCertificates)

        NotFoundRoute ->
            notFoundView


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
                            [ Button.render Mdl
                                [ 0 ]
                                model.mdl
                                [ Options.onClick Logout
                                , css "margin" "0 24px"
                                ]
                                [ text "Log Out" ]
                            ]
                        ]
                else
                    div [ id "form" ]
                        [ h2 [ class "text-center" ] [ text "Login" ]
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
                            [ Button.render Mdl
                                [ 1 ]
                                model.mdl
                                [ Options.onClick Login
                                , css "margin" "0 24px"
                                ]
                                [ text "Log In" ]
                            ]
                        ]
    in
        div [ class "container" ]
            [ h2 [ class "text-center" ] [ text "Spaghetti Workflow" ]
            , div [ class "jumbotron text-left" ]
                [ authBoxView
                ]
            ]
            |> Material.Scheme.top


styles : String
styles =
    -- on a single line because multiline strings don't work well on Windows machines
    -- see https://github.com/avh4/elm-format/issues/74
    " .demo-options .mdl-checkbox__box-outline {      border-color: rgba(255, 255, 255, 0.89);    }   .mdl-layout__drawer {      border: none !important;   }   .mdl-layout__drawer .mdl-navigation__link:hover {      background-color: #00BCD4 !important;      color: #37474F !important;    }    "


viewHeader : Model -> Html Msg
viewHeader model =
    Layout.row
        [ Color.background <| Color.color Color.Grey Color.S100
        , Color.text <| Color.color Color.Grey Color.S900
        ]
        [ Layout.title [] [ text "Martinelli's Little Italy" ]
        , Layout.spacer
        , Layout.navigation []
            []
        ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Msg
    }


menuItems : List MenuItem
menuItems =
    [ { text = "List Gift Certificates", iconName = "view_sequential", route = GiftCertificates }
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html Msg
viewDrawerMenuItem model menuItem =
    Layout.link
        [ Options.onClick menuItem.route
        , Options.css "color" "rgba(255, 255, 255, 0.50)"
        , Options.css "font-weight" "400"
        ]
        [ Icon.view menuItem.iconName
            [ Color.text <| Color.color Color.BlueGrey Color.S500
            , Options.css "margin-right" "32px"
            ]
        , text menuItem.text
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    Layout.navigation
        [ Color.background <| Color.color Color.BlueGrey Color.S800
        , Color.text <| Color.color Color.BlueGrey Color.S50
        , Options.css "flex-grow" "1"
        ]
    <|
        (List.map (viewDrawerMenuItem model) menuItems)


drawerHeader : Model -> Html Msg
drawerHeader model =
    Options.styled Html.header
        [ css "display" "flex"
        , css "box-sizing" "border-box"
        , css "justify-content" "flex-end"
        , css "padding" "16px"
        , css "height" "151px"
        , css "flex-direction" "column"
        , cs "demo-header"
        , Color.background <| Color.color Color.BlueGrey Color.S900
        , Color.text <| Color.color Color.BlueGrey Color.S50
        ]
        [ Options.styled Html.div
            [ css "display" "flex"
            , css "flex-direction" "row"
            , css "align-items" "center"
            , css "width" "100%"
            , css "position" "relative"
            ]
            [ Html.span [] [ text model.username ]
            , Layout.spacer
            , Menu.render Mdl
                [ 1, 2, 3, 4 ]
                model.mdl
                [ Menu.ripple
                , Menu.bottomRight
                , Menu.icon "arrow_drop_down"
                ]
                [ Menu.item
                    [ Menu.onSelect Logout ]
                    [ text "Logout" ]
                ]
            ]
        ]

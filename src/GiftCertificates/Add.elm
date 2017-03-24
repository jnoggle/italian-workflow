module GiftCertificates.Add exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (on)
import Material
import Material.Button as Button
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Icon as Icon
import GiftCertificates.Messages exposing (..)
import GiftCertificates.Models exposing (..)
import Json.Decode as Decode exposing (Decoder)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Add Gift Certificate" ]
        , drawButtons model
        , div
            []
            [ Textfield.render Mdl
                [ 8 ]
                model.mdl
                [ Textfield.label "Memo"
                , Textfield.floatingLabel
                , Textfield.textarea
                , Textfield.rows 6
                , Textfield.maxlength 140
                , Options.onInput SetMemo
                ]
                []
            ]
        , div []
            [ Button.render Mdl
                [ 9 ]
                model.mdl
                [ Button.fab
                , Options.onClick PostGiftCertificate
                ]
                [ Icon.i "add" ]
            ]
        ]


amountOption : Float -> Html Msg
amountOption amount =
    option [ value (toString amount) ] [ text (toString amount) ]


amounts : List Float
amounts =
    [ 5.0, 10.0, 20.0, 25.0, 50.0, 100.0 ]


drawButtons : Model -> Html Msg
drawButtons model =
    div []
        [ amountButton model 5 3
        , amountButton model 10 4
        , amountButton model 20 5
        , amountButton model 25 6
        , amountButton model 50 7
        ]


amountButton : Model -> Float -> Int -> Html Msg
amountButton model amount id =
    Button.render Mdl
        [ id ]
        model.mdl
        [ Button.raised
        , if model.newAmount == amount then
            Button.colored
          else
            Options.nop
        , Options.onClick (SetAmount amount)
        ]
        [ text ("$" ++ toString amount) ]

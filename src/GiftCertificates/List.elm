module GiftCertificates.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Icon as Icon
import GiftCertificates.Messages exposing (..)
import GiftCertificates.Models exposing (..)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "New Gift Certificate" ]
        , addGiftCertificateView model
        , Button.render Mdl
            [ 3 ]
            model.mdl
            [ Options.onClick FetchGiftCertificates ]
            [ text "Gift Certificates" ]
        , div [ class "text-center" ] [ table model.giftCertificates ]
        ]


addGiftCertificateView : Model -> Html Msg
addGiftCertificateView model =
    div []
        [ drawAddButton model
        , drawButtons model
        , drawMemoField model
        ]


table : List GiftCertificate -> Html Msg
table giftCertificates =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "ID" ]
                , Table.th [] [ text "Amount" ]
                , Table.th [] [ text "Sale Price" ]
                , Table.th [] [ text "Date Sold" ]
                , Table.th [] [ text "Date Redeemed" ]
                , Table.th [] [ text "Issuer ID" ]
                , Table.th [] [ text "Memo" ]
                ]
            ]
        , Table.tbody []
            (giftCertificates |> List.map giftCertificateRow)
        ]


giftCertificateRow : GiftCertificate -> Html Msg
giftCertificateRow giftCertificate =
    Table.tr []
        [ Table.td [ Table.numeric ] [ text (toString giftCertificate.id) ]
        , Table.td [ Table.numeric ] [ text (toString giftCertificate.amount) ]
        , Table.td [ Table.numeric ] [ text (toString giftCertificate.sale_price) ]
        , Table.td [] [ text giftCertificate.date_sold ]
        , Table.td []
            [ text
                (case giftCertificate.redeemed_date of
                    Maybe.Just string ->
                        string

                    Maybe.Nothing ->
                        ""
                )
            ]
        , Table.td [ Table.numeric ] [ text (toString giftCertificate.issuer_id) ]
        , Table.td []
            [ text
                (case giftCertificate.memo of
                    Maybe.Just string ->
                        string

                    Maybe.Nothing ->
                        ""
                )
            ]
        ]


drawButtons : Model -> Html Msg
drawButtons model =
    div []
        [ amountButton model 5 3
        , amountButton model 10 4
        , amountButton model 20 5
        , amountButton model 25 6
        , amountButton model 50 7
        ]


drawMemoField : Model -> Html Msg
drawMemoField model =
    div []
        [ Textfield.render Mdl
            [ 8 ]
            model.mdl
            [ Textfield.label "Memo"
            , Textfield.floatingLabel
            , Textfield.textarea
            , Textfield.maxlength 140
            , Textfield.value model.newMemo
              -- The value property is only necessary due to issue 278 in elm-mdl https://github.com/debois/elm-mdl/issues/278
              -- It should be removed once the issue is closed to fix the slow, jumpy behavior of the textfield
              -- when text is being entered in too quickly. This is a result of updating the model's newMemo and
              -- feeding it back through to the textfield.
            , Options.onInput SetMemo
            , Options.css "margin" "0 10px"
            ]
            []
        ]


drawAddButton : Model -> Html Msg
drawAddButton model =
    div []
        [ Button.render Mdl
            [ 9 ]
            model.mdl
            [ Button.raised
            , if model.newAmount == 0.0 then
                Button.disabled
              else
                Button.colored
            , Options.onClick PostGiftCertificate
            , Options.css "float" "left"
            , Options.css "margin" "25px 10px"
            ]
            [ Icon.i "add" ]
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
        , Options.css "float" "left"
        , Options.css "margin" "25px 10px"
        ]
        [ text ("$" ++ toString amount) ]

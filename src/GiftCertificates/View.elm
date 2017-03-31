module GiftCertificates.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.Tabs as Tabs
import Material.Layout as Layout
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)
import DatePicker exposing (DatePicker)
import GiftCertificates.Messages exposing (..)
import GiftCertificates.Models exposing (..)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Tabs.render Mdl
        [ 10 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab SelectTab
        , Tabs.activeTab model.tab
        ]
        [ Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "New"
            ]
        , Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "Reports"
            ]
        , Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "Redeem"
            ]
        ]
        [ Options.div
            [ Options.center
            ]
            [ case model.tab of
                0 ->
                    newTab model

                1 ->
                    reportsTab model

                2 ->
                    redeemTab model

                _ ->
                    newTab model
            ]
        ]


newTab : Model -> Html Msg
newTab model =
    Options.div
        []
        [ addGiftCertificateView model
        , table model.giftCertificates
        ]


reportsTab : Model -> Html Msg
reportsTab model =
    Options.div
        [ Options.css "margin" "50px 25px"
        ]
        [ text "From"
        , DatePicker.view model.beginDatePicker
            |> Html.map ToBeginDatePicker
        , text "To"
        , DatePicker.view model.endDatePicker
            |> Html.map ToEndDatePicker
        , loadReportsButton model
        , table model.giftCertificates
        ]


loadReportsButton : Model -> Html Msg
loadReportsButton model =
    Button.render Mdl
        [ 13 ]
        model.mdl
        [ Button.raised
        , case model.beginDate of
            Just beginDate ->
                case model.endDate of
                    Just endDate ->
                        Button.colored

                    _ ->
                        Button.disabled

            _ ->
                Button.disabled
        , Options.onClick FetchGiftCertificatesByDates
        , Options.css "margin" "50px 25px"
        ]
        [ Icon.i "load" ]


redeemTab : Model -> Html Msg
redeemTab model =
    Options.div
        []
        [ redeemTextField model
        , redeemButton model
        ]


redeemButton : Model -> Html Msg
redeemButton model =
    Button.render Mdl
        [ 12 ]
        model.mdl
        [ Button.raised
        , if model.redeemId == "" then
            Button.disabled
          else
            Button.colored
        , Options.onClick RedeemGiftCertificate
        , Options.css "margin" "50px 25px"
        ]
        [ Icon.i "add" ]


redeemTextField : Model -> Html Msg
redeemTextField model =
    Textfield.render Mdl
        [ 11 ]
        model.mdl
        [ Textfield.label "Gift Certificate Id"
        , Textfield.text_
        , Textfield.value model.redeemId
        , Options.onInput SetRedeemId
        , Options.css "margin" "50px 25px"
        ]
        []


addGiftCertificateView : Model -> Html Msg
addGiftCertificateView model =
    Options.div
        []
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

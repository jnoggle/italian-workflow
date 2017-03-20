module GiftCertificates.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options
import GiftCertificates.Messages exposing (..)
import GiftCertificates.Models exposing (..)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div []
        [ Button.render Mdl
            [ 3 ]
            model.mdl
            [ Options.onClick FetchGiftCertificates ]
            [ text "Load Gift Certificates" ]
        , div [ class "text-center" ] [ table model.giftCertificates ]
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
                    Maybe.Just a ->
                        a

                    Maybe.Nothing ->
                        ""
                )
            ]
        , Table.td [ Table.numeric ] [ text (toString giftCertificate.issuer_id) ]
        , Table.td []
            [ text
                (case giftCertificate.memo of
                    Maybe.Just a ->
                        a

                    Maybe.Nothing ->
                        ""
                )
            ]
        ]

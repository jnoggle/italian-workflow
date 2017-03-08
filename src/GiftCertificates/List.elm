module GiftCertificates.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Table as Table
import GiftCertificates.Messages exposing (..)
import GiftCertificates.Models exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ table model.giftCertificates
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
        [ Table.td [ Table.numeric ] [ text giftCertificate.id ]
        , Table.td [ Table.numeric ] [ text giftCertificate.amount ]
        , Table.td [ Table.numeric ] [ text giftCertificate.sale_price ]
        , Table.td [] [ text giftCertificate.date_sold ]
        , Table.td [] [ text giftCertificate.redeemed_date ]
        , Table.td [ Table.numeric ] [ text giftCertificate.issuer_id ]
        , Table.td [] [ text giftCertificate.memo ]
        ]

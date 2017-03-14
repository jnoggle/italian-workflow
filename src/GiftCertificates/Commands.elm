module GiftCertificates.Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, field)
import Json.Encode as Encode
import GiftCertificates.Models exposing (GiftCertificate)
import GiftCertificates.Messages exposing (Msg(..))


fetchAll : Cmd Msg
fetchAll =
    Cmd.none


giftCertificateUrl : String
giftCertificateUrl =
    apiUrl ++ "gift-certificates"


giftCertificateEncoder : GiftCertificate -> Encode.Value
giftCertificateEncoder giftCertificate =
    Encode.object
        [ ( "amount", Encode.string giftCertificate.amount )
        , ( "sale_price", Encode.string giftCertificate.sale_price )
        , ( "memo", Encode.string giftCertificate.memo )
        ]


postGiftCertificate : GiftCertificate -> String -> Http.Request String
postGiftCertificate giftCertificate apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson giftCertificateDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = giftCertificateUrl
        , body = giftCertificateEncoder giftCertificate |> Http.jsonBody
        }



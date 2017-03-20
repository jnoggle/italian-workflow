module GiftCertificates.Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, field, maybe)
import Json.Encode as Encode
import GiftCertificates.Models exposing (GiftCertificate)
import GiftCertificates.Messages exposing (Msg(..))


apiUrl : String
apiUrl =
    "http://localhost:3001/"


giftCertificateUrl : String
giftCertificateUrl =
    apiUrl ++ "gift-certificates"


giftCertificateEncoder : GiftCertificate -> Encode.Value
giftCertificateEncoder giftCertificate =
    Encode.object
        [ ( "amount", Encode.float giftCertificate.amount )
        , ( "sale_price", Encode.float giftCertificate.sale_price )
        , ( "memo"
          , (case giftCertificate.memo of
                Maybe.Just a ->
                    Encode.string a

                Nothing ->
                    Encode.null
            )
          )
        ]


postGiftCertificate : GiftCertificate -> String -> Http.Request GiftCertificate
postGiftCertificate giftCertificate apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson giftCertificateDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = giftCertificateEncoder giftCertificate |> Http.jsonBody
        }


getGiftCertificates : String -> Http.Request (List GiftCertificate)
getGiftCertificates apiUrl =
    Http.request
        { method = "GET"
        , expect = Http.expectJson (Decode.list giftCertificateDecoder)
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = Http.emptyBody
        }


postGiftCertificateCmd : GiftCertificate -> Cmd Msg
postGiftCertificateCmd giftCertificate =
    Http.send OnGiftCertificatePosted <| postGiftCertificate giftCertificate giftCertificateUrl



-- fetchAll : Cmd Msg
-- fetchAll =
--     Http.get giftCertificateUrl (Decode.list giftCertificateDecoder)
--         |> Http.send OnFetchAll


fetchAll : Cmd Msg
fetchAll =
    Http.send OnFetchAll <| getGiftCertificates giftCertificateUrl


giftCertificateDecoder : Decoder GiftCertificate
giftCertificateDecoder =
    Decode.map7
        GiftCertificate
        (field "gift_certificate_id" Decode.int)
        (field "amount" Decode.float)
        (field "sale_price" Decode.float)
        (field "date_sold" Decode.string)
        (maybe (field "date_redeemed" Decode.string))
        (field "issuer_id" Decode.int)
        (maybe (field "memo" Decode.string))

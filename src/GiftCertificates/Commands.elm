module GiftCertificates.Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, field, maybe)
import Json.Encode as Encode
import Date exposing (Date, day, month, year)
import Date.Extra exposing (monthNumber)
import GiftCertificates.Models exposing (GiftCertificate)
import GiftCertificates.Messages exposing (Msg(..))


apiUrl : String
apiUrl =
    "http://localhost:3001/"


giftCertificateUrl : String
giftCertificateUrl =
    apiUrl ++ "gift-certificates"


todayUrl : String
todayUrl =
    giftCertificateUrl ++ "/today"


redeemUrl : String
redeemUrl =
    giftCertificateUrl ++ "/redeem"


byDatesUrl : String
byDatesUrl =
    giftCertificateUrl ++ "/bydates"


giftCertificateEncoder : Float -> Float -> Maybe String -> Encode.Value
giftCertificateEncoder amount sale_price memo =
    Encode.object
        [ ( "amount", Encode.float amount )
        , ( "sale_price", Encode.float sale_price )
        , ( "memo"
          , (case memo of
                Maybe.Just a ->
                    Encode.string a

                Nothing ->
                    Encode.null
            )
          )
        ]


datesEncoder : Date -> Date -> Encode.Value
datesEncoder beginDate endDate =
    -- Encode.object
    --     [ ( "begin_date", Encode.string "2017-3-27" )
    --     , ( "end_date", Encode.string "2017-3-20" )
    --     ]
    Encode.object
        [ ( "begin_date", Encode.string (formatDate beginDate) )
        , ( "end_date", Encode.string (formatDate endDate) )
        ]


formatDate : Date -> String
formatDate d =
    toString (year d) ++ "-" ++ toString (monthNumber d) ++ "-" ++ toString (day d)


postGiftCertificate : Float -> Float -> Maybe String -> String -> Http.Request GiftCertificate
postGiftCertificate amount sale_price memo apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson giftCertificateDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = (giftCertificateEncoder amount sale_price memo) |> Http.jsonBody
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


getGiftCertificatesByDates : Date -> Date -> String -> Http.Request (List GiftCertificate)
getGiftCertificatesByDates beginDate endDate apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson (Decode.list giftCertificateDecoder)
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = (datesEncoder beginDate endDate) |> Http.jsonBody
        }


redeemGiftCertificate : String -> String -> Http.Request String
redeemGiftCertificate id apiUrl =
    Http.request
        { method = "PUT"
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = (Encode.object [ ( "id", Encode.string id ) ]) |> Http.jsonBody
        }


redeemGiftCertificateCmd : String -> Cmd Msg
redeemGiftCertificateCmd id =
    Http.send OnGiftCertificateRedeemed <| (redeemGiftCertificate id) redeemUrl


postGiftCertificateCmd : Float -> Float -> Maybe String -> Cmd Msg
postGiftCertificateCmd amount sale_price memo =
    Http.send OnGiftCertificatePosted <| (postGiftCertificate amount sale_price memo) giftCertificateUrl


fetchAll : Cmd Msg
fetchAll =
    Http.send OnFetch <| getGiftCertificates giftCertificateUrl


fetchTodays : Cmd Msg
fetchTodays =
    Http.send OnFetchTodays <| getGiftCertificates todayUrl


fetchByDates : Date -> Date -> Cmd Msg
fetchByDates beginDate endDate =
    Http.send OnFetch <| (getGiftCertificatesByDates beginDate endDate) byDatesUrl


giftCertificateDecoder : Decoder GiftCertificate
giftCertificateDecoder =
    Decode.map7
        GiftCertificate
        (field "gift_certificate_id" Decode.string)
        (field "amount" Decode.float)
        (field "sale_price" Decode.float)
        (field "date_sold" Decode.string)
        (maybe (field "date_redeemed" Decode.string))
        (field "issuer_id" Decode.string)
        (maybe (field "memo" Decode.string))

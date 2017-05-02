module OverShorts.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, maybe)
import Json.Encode as Encode
import Date exposing (Date, day, month, year)
import Date.Extra exposing (monthNumber)
import OverShorts.Models exposing (OverShort)
import OverShorts.Messages exposing (Msg(..))


apiUrl : String
apiUrl =
    "http://localhost:3001/"


overShortUrl : String
overShortUrl =
    apiUrl ++ "over-shorts"


todayUrl : String
todayUrl =
    overShortUrl ++ "/today"


byDatesUrl : String
byDatesUrl =
    overShortUrl ++ "/bydates"


overShortEncoder : String -> Bool -> String -> Encode.Value
overShortEncoder amount billable memo =
    Encode.object
        [ ( "amount"
          , Encode.float
                (Result.withDefault
                    0
                    (String.toFloat amount)
                )
          )
        , ( "billable", Encode.bool billable )
        , ( "memo", Encode.string memo )
        ]


datesEncoder : Date -> Date -> Encode.Value
datesEncoder beginDate endDate =
    Encode.object
        [ ( "begin_date", Encode.string (formatDate beginDate) )
        , ( "end_date", Encode.string (formatDate endDate) )
        ]


formatDate : Date -> String
formatDate d =
    toString (year d) ++ "-" ++ toString (monthNumber d) ++ "-" ++ toString (day d)


postOverShort : String -> Bool -> String -> String -> Http.Request OverShort
postOverShort amount billable memo apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson overShortDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = (overShortEncoder amount billable memo) |> Http.jsonBody
        }


getOverShorts : String -> Http.Request (List OverShort)
getOverShorts apiUrl =
    Http.request
        { method = "GET"
        , expect = Http.expectJson (Decode.list overShortDecoder)
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = Http.emptyBody
        }


getOverShortsByDates : Date -> Date -> String -> Http.Request (List OverShort)
getOverShortsByDates beginDate endDate apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson (Decode.list overShortDecoder)
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = (datesEncoder beginDate endDate) |> Http.jsonBody
        }


postOverShortCmd : String -> Bool -> String -> Cmd Msg
postOverShortCmd amount billable memo =
    Http.send OnOverShortPosted <| (postOverShort amount billable memo) overShortUrl


fetchAll : Cmd Msg
fetchAll =
    Http.send OnFetch <| getOverShorts overShortUrl


fetchTodays : Cmd Msg
fetchTodays =
    Http.send OnFetch <| getOverShorts todayUrl


fetchByDates : Date -> Date -> Cmd Msg
fetchByDates beginDate endDate =
    Http.send OnFetch <| (getOverShortsByDates beginDate endDate) byDatesUrl


overShortDecoder : Decoder OverShort
overShortDecoder =
    Decode.map8
        OverShort
        (field "over_short_id" Decode.int)
        (field "amount" Decode.float)
        (field "billable" Decode.int)
        (maybe (field "amountPaid" Decode.float))
        (field "date_recorded" Decode.string)
        (maybe (field "last_contacted" Decode.string))
        (field "username" Decode.string)
        (field "memo" Decode.string)

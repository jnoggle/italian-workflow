module GiftCertificates.Messages exposing (..)

import Http
import GiftCertificates.Models exposing (GiftCertificate)
import Material
import DatePicker


type Msg
    = FetchGiftCertificates
    | FetchGiftCertificatesByDates
    | OnFetch (Result Http.Error (List GiftCertificate))
    | OnFetchTodays (Result Http.Error (List GiftCertificate))
    | OnGiftCertificateRedeemed (Result Http.Error String)
    | SetAmount Float
    | SetMemo String
    | SetRedeemId String
    | PostGiftCertificate
    | RedeemGiftCertificate
    | OnGiftCertificatePosted (Result Http.Error GiftCertificate)
    | SelectTab Int
    | ToBeginDatePicker DatePicker.Msg
    | ToEndDatePicker DatePicker.Msg
    | Mdl (Material.Msg Msg)

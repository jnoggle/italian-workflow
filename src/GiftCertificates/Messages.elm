module GiftCertificates.Messages exposing (..)

import Http
import GiftCertificates.Models exposing (GiftCertificate)
import Material


type Msg
    = FetchGiftCertificates
    | OnFetchAll (Result Http.Error (List GiftCertificate))
    | OnFetchTodays (Result Http.Error (List GiftCertificate))
    | OnGiftCertificateRedeemed (Result Http.Error String)
    | SetAmount Float
    | SetMemo String
    | SetRedeemId String
    | PostGiftCertificate
    | RedeemGiftCertificate
    | OnGiftCertificatePosted (Result Http.Error GiftCertificate)
    | SelectTab Int
    | Mdl (Material.Msg Msg)

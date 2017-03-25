module GiftCertificates.Messages exposing (..)

import Http
import GiftCertificates.Models exposing (GiftCertificate)
import Material


type Msg
    = FetchGiftCertificates
    | OnFetchAll (Result Http.Error (List GiftCertificate))
    | SetAmount Float
    | SetMemo String
    | PostGiftCertificate
    | OnGiftCertificatePosted (Result Http.Error GiftCertificate)
    | Mdl (Material.Msg Msg)

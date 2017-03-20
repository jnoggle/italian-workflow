module GiftCertificates.Messages exposing (..)

import Http
import GiftCertificates.Models exposing (GiftCertificate)
import Material


type Msg
    = FetchGiftCertificates
    | OnFetchAll (Result Http.Error (List GiftCertificate))
    | ListGiftCertificates
    | AddGiftCertificate
    | OnGiftCertificatePosted (Result Http.Error GiftCertificate)
    | Mdl (Material.Msg Msg)

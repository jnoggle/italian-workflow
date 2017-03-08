module GiftCertificates.Messages exposing (..)

import Http
import GiftCertificates.Models exposing (GiftCertificate)


type Msg
    = OnFetchAll (Result Http.Error (List GiftCertificate))
    | ListGiftCertificates
    | AddGiftCertificate
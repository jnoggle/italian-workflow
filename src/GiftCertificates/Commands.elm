module GiftCertificates.Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, field)
import Json.Encode as Encode
import GiftCertificates.Models exposing (GiftCertificate)
import GiftCertificates.Messages exposing (Msg(..))


fetchAll : Cmd Msg
fetchAll =
    Cmd.none

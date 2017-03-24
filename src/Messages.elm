module Messages exposing (..)

import Http
import Navigation exposing (Location)
import Material
import Models exposing (Field)
import GiftCertificates.Messages


type Msg
    = LoginFormInput Field String
    | Login
    | Logout
    | Authorization (Result Http.Error String)
    | ListGiftCertificates
    | AddGiftCertificates
    | GiftCertificateMsg GiftCertificates.Messages.Msg
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)

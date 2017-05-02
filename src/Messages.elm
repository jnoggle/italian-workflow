module Messages exposing (..)

import Http
import Material
import Navigation exposing (Location)
import Models exposing (Field)
import GiftCertificates.Messages
import OverShorts.Messages


type Msg
    = LoginFormInput Field String
    | Login
    | Logout
    | Authorization (Result Http.Error String)
    | GiftCertificates
    | GiftCertificateMsg GiftCertificates.Messages.Msg
    | OverShorts
    | OverShortMsg OverShorts.Messages.Msg
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)

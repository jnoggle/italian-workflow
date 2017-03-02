module Messages exposing (..)

import Http
import Navigation exposing (Location)
import Material
import Models exposing (Field)


type Msg
    = LoginFormInput Field String
    | Login
    | Logout
    | Authorization (Result Http.Error String)
    | GiftCertificates
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)

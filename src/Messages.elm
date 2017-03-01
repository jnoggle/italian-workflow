module Messages exposing (..)

import Http
import Navigation exposing (Location)
import Models exposing (Field)


type Msg
    = LoginFormInput Field String
    | Login
    | Logout
    | Authorization (Result Http.Error String)
    | OnLocationChange Location

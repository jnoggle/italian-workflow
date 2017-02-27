module User.Messages exposing (..)

import Http
import User.Models exposing (..)


type Msg
    = FormInput Field String
    | GetTokenSuccess (Result Http.Error String)
    | RegisterUser
    | LogIn
    | LogOut

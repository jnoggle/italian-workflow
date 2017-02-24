module User.Messages exposing (..)

import Http
import User.Models exposing (..)


type Msg
    = SetUsername String
    | SetPassword String
    | GetTokenSuccess (Result Http.Error String)
    | RegisterUser
    | LogIn
    | LogOut

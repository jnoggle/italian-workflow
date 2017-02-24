module Models exposing (..)

import User.Models exposing (User, emptyUser)
import Routing


type alias Model =
    { user : User
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { user = emptyUser
    , route = route
    }

module Models exposing (..)

import Routing


type Field
    = Username
    | Password


type alias Model =
    { user_id : String
    , username : String
    , password : String
    , token : String
    , errorMsg : String
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    Model "" "" "" "" "" route

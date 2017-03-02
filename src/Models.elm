module Models exposing (..)

import Material
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
    , mdl : Material.Model
    }


initialModel : Routing.Route -> Model
initialModel route =
    Model "" "" "" "" "" route Material.model

module Models exposing (..)

import Material
import Routing
import GiftCertificates.Models exposing (Model)


type Field
    = Username
    | Password


type alias Model =
    { user_id : String
    , username : String
    , password : String
    , token : String
    , errorMsg : String
    , giftCertificates : GiftCertificates.Models.Model
    , route : Routing.Route
    , mdl : Material.Model
    }



-- initialModel : Routing.Route -> Model
-- initialModel route =
--     Model "" "" "" "" "" GiftCertificates.Models.initialModel route Material.model

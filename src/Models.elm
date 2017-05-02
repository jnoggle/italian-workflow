module Models exposing (..)

import Material
import Routing
import GiftCertificates.Models exposing (Model)
import OverShorts.Models exposing (Model)


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
    , overShorts : OverShorts.Models.Model
    , route : Routing.Route
    , mdl : Material.Model
    }

module GiftCertificates.Models exposing (..)

import Material


-- type Maybe a
--     = Just a
--     | Nothing


type alias GiftCertificate =
    { id : Int
    , amount : Float
    , sale_price : Float
    , date_sold : String
    , redeemed_date : Maybe String
    , issuer_id : Int
    , memo : Maybe String
    }


type alias NewGiftCertificate =
    { amount : String
    , sale_price : String
    , memo : String
    }


type alias Model =
    { giftCertificates : List GiftCertificate
    , newGiftCertificate : NewGiftCertificate
    , postedGiftCertificateId : Maybe Int
    , errorMsg : String
    , mdl : Material.Model
    }


initialModel : Model
initialModel =
    Model [] (NewGiftCertificate "" "" "") Maybe.Nothing "" Material.model

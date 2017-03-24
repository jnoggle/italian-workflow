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


type alias Model =
    { giftCertificates : List GiftCertificate
    , newAmount : Float
    , newSale_price : Float
    , newMemo : String
    , postedGiftCertificateId : Maybe Int
    , errorMsg : String
    , mdl : Material.Model
    }


initialModel : Model
initialModel =
    Model [] 0.0 0.0 "" Maybe.Nothing "" Material.model

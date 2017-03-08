module GiftCertificates.Models exposing (..)

import Material


type Maybe a
    = Just a
    | Nothing


type alias GiftCertificate =
    { id : String
    , amount : String
    , sale_price : String
    , date_sold : String
    , redeemed_date : String
    , issuer_id : String
    , memo : String
    }


type alias NewGiftCertificate =
    { amount : String
    , sale_price : String
    , memo : String
    }


type alias Model =
    { giftCertificates : List GiftCertificate
    , newGiftCertificate : NewGiftCertificate
    , mdl : Material.Model
    }


initialModel : Model
initialModel =
    Model [] (NewGiftCertificate "" "" "") Material.model

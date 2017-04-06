module GiftCertificates.Models exposing (..)

import Material
import DatePicker exposing (defaultSettings)
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)


type alias GiftCertificate =
    { id : String
    , amount : Float
    , sale_price : Float
    , date_sold : String
    , redeemed_date : Maybe String
    , issuer_id : String
    , memo : Maybe String
    }


type alias Model =
    { giftCertificates : List GiftCertificate
    , newAmount : Float
    , newSale_price : Float
    , newMemo : String
    , redeemId : String
    , redemptionStatus : String
    , errorMsg : String
    , beginDate : Maybe Date
    , endDate : Maybe Date
    , beginDatePicker : DatePicker.DatePicker
    , endDatePicker : DatePicker.DatePicker
    , mdl : Material.Model
    , tab : Int
    }



-- initialModel : Model
-- initialModel =
--     Model [] 0.0 0.0 "" "" "" "" Nothing Nothing DatePicker.init Material.model 0

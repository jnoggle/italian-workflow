module OverShorts.Models exposing (..)

import Material
import DatePicker exposing (defaultSettings)
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)


type alias OverShort =
    { id : Int
    , amount : Float
    , billable : Int
    , amountPaid : Maybe Float
    , date_recorded : String
    , last_contacted : Maybe String
    , username : String
    , memo : String
    }


type alias Model =
    { overShorts : List OverShort
    , newAmount : String
    , newMemo : String
    , newBillable : Bool
    , paymentId : String
    , errorMsg : String
    , beginDate : Maybe Date
    , endDate : Maybe Date
    , beginDatePicker : DatePicker.DatePicker
    , endDatePicker : DatePicker.DatePicker
    , mdl : Material.Model
    , tab : Int
    }

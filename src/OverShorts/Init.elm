module OverShorts.Init exposing (init)

import Material
import DatePicker exposing (defaultSettings)
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)
import OverShorts.Commands exposing (fetchTodays)
import OverShorts.Models exposing (Model)
import OverShorts.Messages exposing (Msg(..))


init : ( Model, Cmd Msg )
init =
    let
        ( beginDatePicker, beginDatePickerFx ) =
            DatePicker.init defaultSettings

        ( endDatePicker, endDatePickerFx ) =
            DatePicker.init defaultSettings

        model =
            { overShorts = []
            , newAmount = ""
            , newMemo = ""
            , newBillable = False
            , paymentId = ""
            , errorMsg = ""
            , beginDate = Nothing
            , endDate = Nothing
            , beginDatePicker = beginDatePicker
            , endDatePicker = endDatePicker
            , mdl = Material.model
            , tab = 0
            }
    in
        ( model, Cmd.batch [ Cmd.map ToBeginDatePicker beginDatePickerFx, Cmd.map ToEndDatePicker endDatePickerFx, fetchTodays ] )

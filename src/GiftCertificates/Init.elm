module GiftCertificates.Init exposing (init)

import Material
import DatePicker exposing (defaultSettings)
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)
import GiftCertificates.Commands exposing (fetchTodays)
import GiftCertificates.Models exposing (Model)
import GiftCertificates.Messages exposing (Msg(..))


init : ( Model, Cmd Msg )
init =
    let
        ( beginDatePicker, beginDatePickerFx ) =
            DatePicker.init defaultSettings

        ( endDatePicker, endDatePickerFx ) =
            DatePicker.init defaultSettings

        model =
            { giftCertificates = []
            , newAmount = 0.0
            , newSale_price = 0.0
            , newMemo = ""
            , redeemId = ""
            , redemptionStatus = ""
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

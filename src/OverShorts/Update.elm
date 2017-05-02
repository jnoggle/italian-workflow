module OverShorts.Update exposing (..)

import OverShorts.Messages exposing (Msg(..))
import OverShorts.Models exposing (Model, OverShort)
import Navigation
import Material
import OverShorts.Commands exposing (fetchAll, postOverShortCmd, fetchByDates)
import DatePicker


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        FetchOverShorts ->
            ( model, fetchAll )

        FetchOverShortsByDates ->
            case model.beginDate of
                Just beginDate ->
                    case model.endDate of
                        Just endDate ->
                            ( model, fetchByDates beginDate endDate )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        OnFetch result ->
            case result of
                Ok newOverShorts ->
                    ( { model | overShorts = newOverShorts }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        SetAmount amount ->
            ( { model | newAmount = amount }, Cmd.none )

        SetMemo memo ->
            ( { model | newMemo = memo }, Cmd.none )

        ToggleBillable ->
            ( { model | newBillable = not model.newBillable }, Cmd.none )

        PostOverShort ->
            ( { model | newBillable = False, newMemo = "", newAmount = "" }, postOverShortCmd model.newAmount model.newBillable model.newMemo )

        OnOverShortPosted result ->
            case result of
                Ok postedOverShort ->
                    ( { model | overShorts = postedOverShort :: model.overShorts }, Cmd.none )

                Err error ->
                    ( { model | errorMsg = (toString error) }, Cmd.none )

        SelectTab index ->
            ( { model | tab = index }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        ToBeginDatePicker msg ->
            let
                ( newDatePicker, datePickerFx, mDate ) =
                    DatePicker.update msg model.beginDatePicker

                beginDate =
                    case mDate of
                        Nothing ->
                            model.beginDate

                        date ->
                            date
            in
                { model
                    | beginDate = beginDate
                    , beginDatePicker = newDatePicker
                }
                    ! [ Cmd.map ToBeginDatePicker datePickerFx ]

        ToEndDatePicker msg ->
            let
                ( newDatePicker, datePickerFx, mDate ) =
                    DatePicker.update msg model.endDatePicker

                endDate =
                    case mDate of
                        Nothing ->
                            model.endDate

                        date ->
                            date
            in
                { model
                    | endDate = endDate
                    , endDatePicker = newDatePicker
                }
                    ! [ Cmd.map ToEndDatePicker datePickerFx ]

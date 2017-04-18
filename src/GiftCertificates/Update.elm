module GiftCertificates.Update exposing (..)

import GiftCertificates.Messages exposing (Msg(..))
import GiftCertificates.Models exposing (Model, GiftCertificate)
import Navigation
import Material
import GiftCertificates.Commands exposing (fetchAll, postGiftCertificateCmd, redeemGiftCertificateCmd, fetchByDates)
import DatePicker


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "The Message" message of
        FetchGiftCertificates ->
            ( model, fetchAll )

        FetchGiftCertificatesByDates ->
            case model.beginDate of
                Just beginDate ->
                    case model.endDate of
                        Just endDate ->
                            ( model, fetchByDates beginDate endDate )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        OnFetch (Ok newGiftCertificates) ->
            ( { model | giftCertificates = newGiftCertificates }, Cmd.none )

        OnFetch (Err error) ->
            ( model, Cmd.none )

        OnGiftCertificateRedeemed (Ok msg) ->
            ( { model | redemptionStatus = msg, redeemId = "" }, Cmd.none )

        OnGiftCertificateRedeemed (Err error) ->
            ( { model | redemptionStatus = (toString error), redeemId = "" }, Cmd.none )

        SetAmount amount ->
            ( { model | newAmount = amount, newSale_price = amount }, Cmd.none )

        SetMemo memo ->
            ( { model | newMemo = memo }, Cmd.none )

        SetRedeemId id ->
            ( { model | redeemId = id }, Cmd.none )

        PostGiftCertificate ->
            ( { model | newMemo = "", newAmount = 0.0 }, postGiftCertificateCmd model.newAmount model.newSale_price (Maybe.Just model.newMemo) )

        RedeemGiftCertificate ->
            ( model, redeemGiftCertificateCmd model.redeemId )

        OnGiftCertificatePosted (Ok postedGiftCertificate) ->
            ( { model | giftCertificates = postedGiftCertificate :: model.giftCertificates }, Cmd.none )

        OnGiftCertificatePosted (Err error) ->
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

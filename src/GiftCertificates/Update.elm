module GiftCertificates.Update exposing (..)

import GiftCertificates.Messages exposing (Msg(..))
import GiftCertificates.Models exposing (Model, GiftCertificate, NewGiftCertificate)
import Navigation
import GiftCertificates.Commands


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnFetchAll (Ok newGiftCertificates) ->
            ( { model | giftCertificates = newGiftCertificates }, Cmd.none )

        OnFetchAll (Err error) ->
            ( model, Cmd.none )

        ListGiftCertificates ->
            ( model, Navigation.newUrl "#giftcertificates" )

        AddGiftCertificate ->
            ( model, Navigation.newUrl "#giftcertificates/add" )

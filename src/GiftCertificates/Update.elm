module GiftCertificates.Update exposing (..)

import GiftCertificates.Messages exposing (Msg(..))
import GiftCertificates.Models exposing (Model, GiftCertificate, NewGiftCertificate)
import Navigation
import Material
import GiftCertificates.Commands exposing (fetchAll)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "The Message" message of
        FetchGiftCertificates ->
            ( model, fetchAll )

        OnFetchAll (Ok newGiftCertificates) ->
            ( { model | giftCertificates = newGiftCertificates }, Cmd.none )

        OnFetchAll (Err error) ->
            ( model, Cmd.none )

        ListGiftCertificates ->
            ( model, Navigation.newUrl "#giftcertificates" )

        AddGiftCertificate ->
            ( model, Navigation.newUrl "#giftcertificates/add" )

        OnGiftCertificatePosted (Ok postedGiftCertificate) ->
            ( { model | postedGiftCertificateId = Maybe.Just postedGiftCertificate.id }, Cmd.none )

        OnGiftCertificatePosted (Err error) ->
            ( { model | errorMsg = (toString error) }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

module GiftCertificates.Update exposing (..)

import GiftCertificates.Messages exposing (Msg(..))
import GiftCertificates.Models exposing (Model, GiftCertificate)
import Navigation
import Material
import GiftCertificates.Commands exposing (fetchAll, postGiftCertificateCmd)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case Debug.log "The Message" message of
        FetchGiftCertificates ->
            ( model, fetchAll )

        OnFetchAll (Ok newGiftCertificates) ->
            ( { model | giftCertificates = newGiftCertificates }, Cmd.none )

        OnFetchAll (Err error) ->
            ( model, Cmd.none )

        GiftCertificates ->
            ( model, Navigation.newUrl "#giftcertificates" )

        SetAmount amount ->
            ( { model | newAmount = amount, newSale_price = amount }, Cmd.none )

        SetMemo memo ->
            ( { model | newMemo = memo }, Cmd.none )

        PostGiftCertificate ->
            ( model, postGiftCertificateCmd model.newAmount model.newSale_price (Maybe.Just model.newMemo) )

        OnGiftCertificatePosted (Ok postedGiftCertificate) ->
            ( { model | postedGiftCertificateId = Maybe.Just postedGiftCertificate.id }, Cmd.none )

        OnGiftCertificatePosted (Err error) ->
            ( { model | errorMsg = (toString error) }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

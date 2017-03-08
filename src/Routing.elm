module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = LoginRoute
    | GiftCertificatesRoute
    | AddGiftCertificateRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map LoginRoute (s "login")
        , map GiftCertificatesRoute (s "giftcertificates")
        , map AddGiftCertificateRoute (s "giftcertificates/add")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute

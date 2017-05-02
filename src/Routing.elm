module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, s, map, top, oneOf)


type Route
    = LoginRoute
    | GiftCertificatesRoute
    | OverShortsRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map LoginRoute (s "login")
        , map GiftCertificatesRoute (s "giftcertificates")
        , map OverShortsRoute (s "overshorts")
        ]


parseLocation : Location -> Route
parseLocation location =
    case Debug.log "Location Message" (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute

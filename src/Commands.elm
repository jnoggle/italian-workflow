module Commands exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field)
import Json.Encode as Encode
import Models exposing (Model)
import Messages exposing (..)


apiUrl : String
apiUrl =
    "http://localhost:3001/"


loginUrl : String
loginUrl =
    apiUrl ++ "authenticate"


userEncoder : Model -> Encode.Value
userEncoder model =
    Encode.object
        [ ( "username", Encode.string model.username )
        , ( "password", Encode.string model.password )
        ]


authUser : Model -> String -> Http.Request String
authUser model apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson tokenDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = userEncoder model |> Http.jsonBody
        }


authUserCmd : Model -> String -> Cmd Msg
authUserCmd model apiUrl =
    Http.send Authorization <| authUser model apiUrl


tokenDecoder : Decoder String
tokenDecoder =
    field "id_token" Decode.string

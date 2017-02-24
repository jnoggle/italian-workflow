module User.Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, field)
import Json.Encode as Encode
import User.Models exposing (User)
import User.Messages exposing (..)


apiUrl : String
apiUrl =
    "http://localhost:3001/"


registerUrl : String
registerUrl =
    apiUrl ++ "users"


loginUrl : String
loginUrl =
    apiUrl ++ "sessions/create"


userEncoder : User -> Encode.Value
userEncoder user =
    Encode.object
        [ ( "username", Encode.string user.username )
        , ( "password", Encode.string user.password )
        ]


authUser : User -> String -> Http.Request String
authUser user apiUrl =
    Http.request
        { method = "POST"
        , expect = Http.expectJson tokenDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers = []
        , url = apiUrl
        , body = userEncoder user |> Http.jsonBody
        }


authUserCmd : User -> String -> Cmd Msg
authUserCmd user apiUrl =
    Http.send GetTokenSuccess <| authUser user apiUrl


tokenDecoder : Decoder String
tokenDecoder =
    field "id_token" Decode.string

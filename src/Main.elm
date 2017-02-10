port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)


main : Program (Maybe Model) Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type alias Model =
    { username : String
    , password : String
    , token : String
    , errorMsg : String
    }


emptyModel : Model
emptyModel =
    Model "" "" "" ""


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    Maybe.withDefault emptyModel savedModel ! []



-- MESSAGES


type Msg
    = SetUsername String
    | SetPassword String
    | GetTokenSuccess (Result Http.Error String)
    | ClickRegisterUser
    | ClickLogIn
    | LogOut



-- PORTS


port setStorage : Model -> Cmd msg


port removeStorage : Model -> Cmd msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetUsername username ->
            ( { model | username = username }, Cmd.none )

        SetPassword password ->
            ( { model | password = password }, Cmd.none )

        ClickRegisterUser ->
            ( model, authUserCmd model registerUrl )

        GetTokenSuccess (Ok newToken) ->
            ( { model | token = newToken, password = "", errorMsg = "" }, setStorage model )

        GetTokenSuccess (Err error) ->
            ( { model | errorMsg = (toString error) }, Cmd.none )

        ClickLogIn ->
            ( model, authUserCmd model loginUrl )

        LogOut ->
            ( { model | username = "", token = "" }, removeStorage model )



-- HTTP


apiUrl : String
apiUrl =
    "http://localhost:3001/"


registerUrl : String
registerUrl =
    apiUrl ++ "users"


loginUrl : String
loginUrl =
    apiUrl ++ "sessions/create"


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
    Http.send GetTokenSuccess <| authUser model apiUrl


tokenDecoder : Decoder String
tokenDecoder =
    field "id_token" Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    let
        loggedIn : Bool
        loggedIn =
            if String.length model.token > 0 then
                True
            else
                False

        authBoxView =
            let
                showError : String
                showError =
                    if String.isEmpty model.errorMsg then
                        "hidden"
                    else
                        ""

                greeting : String
                greeting =
                    "Hello, " ++ model.username ++ "!"
            in
                if loggedIn then
                    div [ id "greeting" ]
                        [ h3 [ class "text-center" ] [ text greeting ]
                        , p [ class "text-center" ] [ text "You are logged in" ]
                        , p [ class "text-center" ]
                            [ button [ class "btn btn-danger", onClick LogOut ] [ text "Log Out" ]
                            ]
                        ]
                else
                    div [ id "form" ]
                        [ h2 [ class "text-center" ] [ text "Log in or Register" ]
                        , p [ class "help-block" ] [ text "If you already have an account, please Log In. Otherwise, enter your desired username and password and Register." ]
                        , div [ class showError ]
                            [ div [ class "alert alert-danger" ] [ text model.errorMsg ]
                            ]
                        , div [ class "form-group row" ]
                            [ div [ class "col-md-offset-2 col-md-8" ]
                                [ label [ for "username" ] [ text "Username:" ]
                                , input [ id "username", type_ "text", class "form-control", Html.Attributes.value model.username, onInput SetUsername ] []
                                ]
                            ]
                        , div [ class "form-group row" ]
                            [ div [ class "col-md-offset-2 col-md-8" ]
                                [ label [ for "password" ] [ text "Password:" ]
                                , input [ id "password", type_ "password", class "form-control", Html.Attributes.value model.password, onInput SetPassword ] []
                                ]
                            ]
                        , div [ class "text-center" ]
                            [ button [ class "btn btn-primary", onClick ClickLogIn ] [ text "Log In" ]
                            , button [ class "btn btn-link", onClick ClickRegisterUser ] [ text "Register" ]
                            ]
                        ]
    in
        div [ class "container" ]
            [ h2 [ class "text-center" ] [ text "Spaghetti Workflow" ]
            , div [ class "jumbotron text-left" ]
                [ authBoxView
                ]
            ]

module User.Models exposing (..)


type Field
    = Username
    | Password


type alias User =
    { id : String
    , username : String
    , password : String
    , token : String
    , msg : String
    }


emptyUser : User
emptyUser =
    User "" "" "" "" ""

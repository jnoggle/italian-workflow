module User.Models exposing (..)


type alias UserId =
    String


type alias User =
    { id : UserId
    , username : String
    , password : String
    , token : String
    , errorMsg : String
    }


emptyUser : User
emptyUser =
    User "" "" "" "" ""

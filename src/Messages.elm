module Messages exposing (..)

import Navigation exposing (Location)
import User.Messages


type Msg
    = UserMsg User.Messages.Msg
    | OnLocationChange Location

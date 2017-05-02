module OverShorts.Messages exposing (..)

import Http
import OverShorts.Models exposing (OverShort)
import Material
import DatePicker


type Msg
    = FetchOverShorts
    | FetchOverShortsByDates
    | OnFetch (Result Http.Error (List OverShort))
    | SetAmount String
    | SetMemo String
    | ToggleBillable
    | PostOverShort
    | OnOverShortPosted (Result Http.Error OverShort)
    | SelectTab Int
    | ToBeginDatePicker DatePicker.Msg
    | ToEndDatePicker DatePicker.Msg
    | Mdl (Material.Msg Msg)

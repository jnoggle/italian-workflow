module OverShorts.View exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.Tabs as Tabs
import Material.Layout as Layout
import Material.Toggles as Toggles
import Date exposing (Date, Day(..), day, dayOfWeek, month, year)
import DatePicker exposing (DatePicker)
import Regex
import OverShorts.Messages exposing (Msg(..))
import OverShorts.Models exposing (Model, OverShort)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Tabs.render Mdl
        [ 10 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab SelectTab
        , Tabs.activeTab model.tab
        ]
        [ Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "New"
            ]
        , Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "Reports"
            ]
        , Tabs.label
            [ Options.center ]
            [ Options.span [ Options.css "width" "4px" ] []
            , text "Enter Payment"
            ]
        ]
        [ Options.div
            [ Options.center
            ]
            [ case model.tab of
                0 ->
                    newTab model

                1 ->
                    reportsTab model

                2 ->
                    enterPaymentTab model

                _ ->
                    newTab model
            ]
        ]


newTab : Model -> Html Msg
newTab model =
    Options.div
        []
        [ addOverShortView model
        , table model.overShorts
        ]


reportsTab : Model -> Html Msg
reportsTab model =
    Options.div
        [ Options.css "margin" "50px 25px"
        , Options.css "text-align" "center"
        ]
        [ Options.div
            [ Options.css "margin" "auto"
            ]
            [ text "From "
            , DatePicker.view model.beginDatePicker
                |> Html.map ToBeginDatePicker
            , text "To "
            , DatePicker.view model.endDatePicker
                |> Html.map ToEndDatePicker
            ]
        , loadReportsButton model
        , table model.overShorts
        ]


loadReportsButton : Model -> Html Msg
loadReportsButton model =
    Button.render Mdl
        [ 13 ]
        model.mdl
        [ Button.raised
        , case model.beginDate of
            Just beginDate ->
                case model.endDate of
                    Just endDate ->
                        Button.colored

                    _ ->
                        Button.disabled

            _ ->
                Button.disabled
        , Options.onClick FetchOverShortsByDates
        , Options.css "margin" "50px 25px"
        ]
        [ Icon.i "add" ]


enterPaymentTab : Model -> Html Msg
enterPaymentTab model =
    Options.div
        []
        [ enterPaymentIdTextfield model
        , enterPaymentAmountTextfield model
        , enterPaymentButton model
        ]


enterPaymentIdTextfield : Model -> Html Msg
enterPaymentIdTextfield model =
    Textfield.render Mdl
        [ 11 ]
        model.mdl
        [ Textfield.label "Over/Short Id"
        , Textfield.text_
          -- , Textfield.value model.newPaymentId
        , Textfield.autofocus
          -- , Options.onInput SetPaymentId
        , Options.css "margin" "50px 25px"
        ]
        []


enterPaymentAmountTextfield : Model -> Html Msg
enterPaymentAmountTextfield model =
    Textfield.render Mdl
        [ 12 ]
        model.mdl
        [ Textfield.label "Payment Amount"
        , Textfield.text_
          -- , Textfield.value model.newPayment
        , Textfield.autofocus
          -- , Options.onInput SetPaymentAmount
        , Options.css "margin" "50px 25px"
        ]
        []


enterPaymentButton : Model -> Html Msg
enterPaymentButton model =
    div []
        [ Button.render Mdl
            [ 18 ]
            model.mdl
            [ Button.raised
              -- , if model.newPayment == 0.0 then
              --     Button.disabled
              --   else
              --     Button.colored
              -- , Options.onClick PostPayment
            , Options.css "float" "left"
            , Options.css "margin" "25px 10px"
            ]
            [ Icon.i "add" ]
        ]


addOverShortView : Model -> Html Msg
addOverShortView model =
    Options.div
        []
        [ drawAddButton model
        , drawAmountField model
        , drawBillableCheckBox model
        , drawMemoField model
        ]


table : List OverShort -> Html Msg
table overShorts =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "ID" ]
                , Table.th [] [ text "Amount" ]
                , Table.th [] [ text "Billable" ]
                , Table.th [] [ text "Amount Paid" ]
                , Table.th [] [ text "Date Recorded" ]
                , Table.th [] [ text "Last Contacted" ]
                , Table.th [] [ text "Issuer" ]
                , Table.th [] [ text "Memo" ]
                ]
            ]
        , Table.tbody []
            (overShorts |> List.map overShortRow)
        ]


overShortRow : OverShort -> Html Msg
overShortRow overShort =
    Table.tr []
        [ Table.td [ Table.numeric ] [ text (toString overShort.id) ]
        , Table.td [ Table.numeric ] [ text (toString overShort.amount) ]
        , Table.td [ Table.numeric ] [ text (toYesNo overShort.billable) ]
        , Table.td [ Table.numeric ]
            [ text
                (toString
                    (case overShort.amountPaid of
                        Just float ->
                            float

                        Nothing ->
                            0.0
                    )
                )
            ]
        , Table.td [] [ text overShort.date_recorded ]
        , Table.td []
            [ text
                (case overShort.last_contacted of
                    Just string ->
                        string

                    Nothing ->
                        ""
                )
            ]
        , Table.td [] [ text overShort.username ]
        , Table.td [] [ text overShort.memo ]
        ]


toYesNo : Int -> String
toYesNo int =
    case int of
        1 ->
            "Yes"

        _ ->
            "No"


drawAddButton : Model -> Html Msg
drawAddButton model =
    div []
        [ Button.render Mdl
            [ 9 ]
            model.mdl
            [ Button.raised
            , if ((model.newAmount == "") || (model.newMemo == "")) then
                Button.disabled
              else
                Button.colored
            , Options.onClick PostOverShort
            , Options.css "float" "left"
            , Options.css "margin" "25px 10px"
            ]
            [ Icon.i "add" ]
        ]


drawAmountField : Model -> Html Msg
drawAmountField model =
    div []
        [ Textfield.render Mdl
            [ 8 ]
            model.mdl
            [ Textfield.label "Amount"
            , Textfield.error ("Invalid Amount")
                |> Options.when (not <| match model.newAmount rx_)
            , Textfield.value model.newAmount
              -- The value property is only necessary due to issue 278 in elm-mdl https://github.com/debois/elm-mdl/issues/278
              -- It should be removed once the issue is closed to fix the slow, jumpy behavior of the textfield
              -- when text is being entered in too quickly. This is a result of updating the model's newMemo and
              -- feeding it back through to the textfield.
            , Options.onInput SetAmount
            , Options.css "margin" "0 10px"
            ]
            []
        ]


rx : String
rx =
    "[+-]?[0-9]*(\\.[0-9]{2})?"


rx_ : Regex.Regex
rx_ =
    Regex.regex rx


match : String -> Regex.Regex -> Bool
match str rx =
    Regex.find Regex.All rx str
        |> List.any (.match >> (==) str)


drawBillableCheckBox : Model -> Html Msg
drawBillableCheckBox model =
    div []
        [ Toggles.checkbox Mdl
            [ 16 ]
            model.mdl
            [ Options.onToggle ToggleBillable
            , Toggles.ripple
            , Toggles.value model.newBillable
            ]
            [ text "Billable" ]
        ]


drawMemoField : Model -> Html Msg
drawMemoField model =
    div []
        [ Textfield.render Mdl
            [ 8 ]
            model.mdl
            [ Textfield.label "Memo"
            , Textfield.floatingLabel
            , Textfield.textarea
            , Textfield.maxlength 140
            , Textfield.value model.newMemo
              -- The value property is only necessary due to issue 278 in elm-mdl https://github.com/debois/elm-mdl/issues/278
              -- It should be removed once the issue is closed to fix the slow, jumpy behavior of the textfield
              -- when text is being entered in too quickly. This is a result of updating the model's newMemo and
              -- feeding it back through to the textfield.
            , Options.onInput SetMemo
            , Options.css "margin" "0 10px"
            ]
            []
        ]

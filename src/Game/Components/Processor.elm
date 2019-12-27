module Game.Components.Processor exposing (Processor, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import Game.CodeInterpreter exposing (Code)

type alias Processor =
    {   code : Code
    }

view : Processor -> Html msg
view processor =
    text "This is a processor."
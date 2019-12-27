module Main exposing (..)

import Browser

import Html exposing (Html, text, div)

type alias Model = Int

type Msg
    = NoOp

main = Browser.element
    {   init = init
    ,   view = view
    ,   subscriptions = subscriptions
    ,   update = update
    }

init : () -> (Model, Cmd Msg)
init _ = (0, Cmd.none)

view : Model -> Html Msg
view model =
    div [] [ text "Hello World" ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)
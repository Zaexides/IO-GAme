module Main exposing (..)

import Browser exposing (Document)

import Html exposing (Html, text, div)
import Html.Attributes exposing (id, class)

import Game exposing (Game)

type alias Model = Game

type Msg
    = GameMsg Game.Msg

main = Browser.document
    {   init = init
    ,   view = view
    ,   subscriptions = subscriptions
    ,   update = update
    }

init : () -> (Model, Cmd Msg)
init _ = (Game.init (), Cmd.none)

view : Model -> Document Msg
view model =
    {   title = "IO Game"
    ,   body = 
        [   Game.view model |> Html.map GameMsg
        ]
    }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GameMsg subMsg ->
            let
                (newGame, subCmd) = Game.update subMsg model
            in
                (   newGame
                ,   Cmd.map GameMsg subCmd
                )
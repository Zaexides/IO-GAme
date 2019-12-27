module Game exposing (Game, GameObject, Component(..), Msg, view, init, update)

import Html exposing (Html, div, article)
import Html.Attributes exposing (id, class, style)
import Html.Events exposing (onMouseDown, onMouseUp)

import Game.Components.Processor as ProcessorComponent exposing (Processor)

type alias Game =
    {   gameObjects : List GameObject
    }

type alias GameObject =
    {   position : (Int, Int)
    ,   isGrabbed : Bool
    ,   component : Component
    }

type Component
    = Processor Processor

type Msg
    = OnStartGrab GameObject
    | OnEndGrab GameObject

init : () -> Game
init _ =
    {   gameObjects =
        [   {   position = (50, 200)
            ,   isGrabbed = False
            ,   component = Processor
                {   code = []
                }
            }
        ]
    }

view : Game -> Html Msg
view game =
    div
    [   id "gameboard"
    ] <| List.map viewGameObject game.gameObjects

viewGameObject : GameObject -> Html Msg
viewGameObject gameObject =
    let
        (x, y) = gameObject.position
    in
        div
        [   style "position" "relative"
        ,   style "top" (String.fromInt x ++ "px")
        ,   style "left" (String.fromInt y ++ "px")
        ,   onMouseDown (OnStartGrab gameObject)
        ]
        [   viewGrabbyPart   
        ,   article
            [   class "gameobject"
            ,   class (getGameObjectComponentClassName gameObject.component)
            ]
            [   getGameObjectViewContents gameObject.component
            ]
        ]

viewGrabbyPart : Html Msg
viewGrabbyPart =
    div
    [   class "grab-area"
    ]
    [
    ]

getGameObjectComponentClassName : Component -> String
getGameObjectComponentClassName component =
    case component of
        Processor _ -> "processor"

getGameObjectViewContents : Component -> Html Msg
getGameObjectViewContents component =
    case component of
        Processor processor -> ProcessorComponent.view processor

update : Msg -> Game -> (Game, Cmd Msg)
update msg game =
    case msg of
        OnStartGrab gameObject -> Debug.todo "~"
        OnEndGrab gameObject -> Debug.todo "~"
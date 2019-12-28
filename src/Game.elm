module Game exposing (Game, GameObject, Component(..), Msg, Position, view, init, update)

import Html exposing (Html, div, article)
import Html.Attributes exposing (id, class, style)
import Html.Events exposing (onMouseDown, onMouseUp, onMouseLeave, on)

import Json.Decode as JSON exposing (Decoder)

import Game.Components.Processor as ProcessorComponent exposing (Processor)

type alias Game =
    {   gameObjects : List GameObject
    }

type alias GameObject =
    {   position : Position
    ,   isGrabbed : Bool
    ,   component : Component
    }

type alias Position =
    {   x : Int
    ,   y : Int
    }

type Component
    = Processor Processor

type Msg
    = OnStartGrab Int
    | OnEndGrab
    | OnMouseMoved Position

init : () -> Game
init _ =
    {   gameObjects =
        [   {   position = { x = 200, y = 50}
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
    ,   onMouseUp OnEndGrab
    ,   onMouseLeave OnEndGrab
    ,   on "mousemove" (JSON.map OnMouseMoved mouseMoveDecoder)
    ] <| List.indexedMap viewGameObject game.gameObjects

viewGameObject : Int -> GameObject -> Html Msg
viewGameObject id gameObject =
    let
        position = gameObject.position
        (x,y) = 
            (   position.x
            ,   position.y
            )
    in
        div
        [   style "position" "relative"
        ,   style "left" (String.fromInt x ++ "px")
        ,   style "top" (String.fromInt y ++ "px")
        ]
        [   viewGrabbyPart gameObject.isGrabbed id
        ,   article
            [   class "gameobject"
            ,   class (getGameObjectComponentClassName gameObject.component)
            ]
            [   getGameObjectViewContents gameObject.component
            ]
        ]

viewGrabbyPart : Bool -> Int -> Html Msg
viewGrabbyPart isGrabbed id =
    div
    [   class (if isGrabbed then "grab-area grabbed" else "grab-area")
    ,   onMouseDown (OnStartGrab id)
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
        OnStartGrab id -> 
            (   { game | gameObjects = List.indexedMap (startGrabStateFor id) game.gameObjects }
            ,   Cmd.none
            )
        OnEndGrab ->
            (   { game | gameObjects = List.map endGrabState game.gameObjects }
            ,   Cmd.none
            )
        OnMouseMoved mousePosition ->
            (   { game | gameObjects = List.map (moveGameObjectToWhenGrabbed mousePosition) game.gameObjects }
            ,   Cmd.none
            )

startGrabStateFor : Int -> Int -> GameObject -> GameObject
startGrabStateFor target current gameObject =
    if (target == current) then
        { gameObject | isGrabbed = True }
    else
        gameObject

endGrabState : GameObject -> GameObject
endGrabState gameObject =
    { gameObject | isGrabbed = False }

movementOffset : Position
movementOffset =
    {   x = -8
    ,   y = -8
    }

moveGameObjectToWhenGrabbed : Position -> GameObject -> GameObject
moveGameObjectToWhenGrabbed targetPosition gameObject =
    if (gameObject.isGrabbed) then
        { gameObject | position = (translatePosition targetPosition movementOffset) }
    else
        gameObject

translatePosition : Position -> Position -> Position
translatePosition position translation =
    {   x = position.x + translation.x
    ,   y = position.y + translation.y
    }

mouseMoveDecoder : Decoder Position
mouseMoveDecoder =
    JSON.map2 Position
        ( JSON.at ["clientX"] JSON.int )
        ( JSON.at ["clientY"] JSON.int )
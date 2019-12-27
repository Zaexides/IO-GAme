module Game.CodeInterpreter exposing (Code, fromString)

type alias Code = List Operation

type Operation
    = Add Int
    | Multiply Int
    | Set Int

fromString : String -> Code
fromString string = Debug.todo "Implement parsing"

execute : Code -> List Int
execute c = []
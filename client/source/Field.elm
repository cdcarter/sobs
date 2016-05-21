module Field exposing (Model, decode, init, render)

import Html exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json


type alias Model =
    { name : String
    , fieldType : String
    }


decode : Json.Decoder Model
decode =
    Json.object2 Model
        (Json.at [ "name" ] Json.string)
        (Json.at [ "type" ] Json.string)


init : String -> String -> Model
init name fieldType =
    Model name fieldType


render : Model -> (Html.Html a)
render { name, fieldType } =
    tr [] [ td [] [ text name ], td [] [ text fieldType ] ]

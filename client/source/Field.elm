module Field exposing (Model, decode, init, render, view)

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


render : msg -> Model -> Html.Html msg
render msg { name, fieldType } =
    tr [] [ td [] [ text name ], td [] [ text fieldType ] ]


view : msg -> Model -> Html.Html msg
view msg model =
    Html.Lazy.lazy2 render msg model

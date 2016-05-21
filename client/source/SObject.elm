module SObject exposing (Model, Msg,helpLoad, init, getSObject, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.App
import Http
import Json.Decode as Json
import Task
import Field


main =
    Html.App.program
        { init = ( init "", getSObject "Unit__c" )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { name : String
    , label : String
    , custom : Bool
    , labelPlural : String
    , customSetting : Bool
    , fields : List Field.Model
    }



-- init


init : String -> Model
init name =
    { name = name
    , label = ""
    , custom = True
    , labelPlural = ""
    , customSetting = False
    , fields = []
    }



-- update
helpLoad : Msg
helpLoad =
  Called


type Msg
    = N
    | Called
    | FetchSucceed Model
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Called ->
            ( model, getSObject model.name )

        N ->
            ( model, Cmd.none )

        FetchSucceed obj ->
            ( obj, Cmd.none )

        FetchFail err ->
            ( model, Cmd.none )


getSObject : String -> Cmd Msg
getSObject name =
    let
        url =
            "https://l8fii0ljb8.execute-api.us-west-2.amazonaws.com/dev/metadata/object/" ++ name
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeSObject url)


decodeSObject : Json.Decoder Model
decodeSObject =
    Json.object6 Model
        (Json.at [ "name" ] Json.string)
        (Json.at [ "label" ] Json.string)
        (Json.at [ "custom" ] Json.bool)
        (Json.at [ "labelPlural" ] Json.string)
        (Json.at [ "customSetting" ] Json.bool)
        (Json.at [ "fields" ] (Json.list Field.decode))



-- view

view : Model -> Html Msg
view model =
  if model.labelPlural  == "" then text "" else render model

render : Model -> Html Msg
render model =
    let
        fieldRows =
            List.map (Field.view N) model.fields

        fieldHeader =
            tr [] [ th [] [ text "Name" ], th [] [ text "Type" ] ]
    in
        div [ ]
            [ h1 [] [ text model.labelPlural ]
            , table []
                [ tr [] [ td [] [ text "Custom?" ], td [] [ text (toString model.custom) ] ]
                , tr [] [ td [] [ text "Custom Setting?" ], td [] [ text (toString model.customSetting) ] ]
                , tr [] [ td [] [ text "API Name" ], td [] [ text model.name ] ]
                ]
            , hr [] []
            , table []
                [ thead [] [ fieldHeader ]
                , tbody [] fieldRows
                ]
            ]

module Main exposing (..)

import Html exposing (div, span, strong, text)
import Html.Attributes exposing (href)
import Html.App
import Html.Events
import SObject


init : String -> ( Model, Cmd Msg )
init name =
    let
        ( sobject, sobFx ) =
            SObject.init name
    in
        ( Model sobject name, Cmd.map Obj sobFx )


type alias Model =
    { sobject : SObject.Model, name : String }


type Msg
    = Obj SObject.Msg
    | Change String
    | Blur


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Obj msg ->
            let
                ( obj, effect ) =
                    SObject.update msg model.sobject
            in
                ( { model | sobject = obj }, Cmd.map Obj effect )

        Blur ->
            let
                ( obj, effect ) =
                    SObject.init model.name
            in
                ( { model | sobject = obj }, Cmd.map Obj effect )
        
        Change str -> 
          ({model |name = str},Cmd.none)

view : Model -> Html.Html Msg
view model =
    div [Html.Attributes.style [("padding","10px")]]
        [ div []
            [ Html.h1 [] [ text "SObject Viewer" ]
            , text ""
            , Html.a [ href "http://github.com/cdcarter/sobs" ] [ text "view on github" ]
            ]
        , div []
            [ Html.input
                [ Html.Attributes.placeholder "ObjectName (try Unit__c)"
                , Html.Events.onInput Change
                , Html.Events.onBlur Blur
                ]
                []
            ]
        , div [] [ Html.App.map Obj (SObject.view model.sobject) ]
        ]


main =
    Html.App.program
        { init = init ""
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

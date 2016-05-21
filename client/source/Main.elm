module Main exposing (..)

import Html exposing (div, span, strong, text)
import Html.Attributes exposing (href)
import Html.App
import Html.Events
import Ui.Container
import Ui.Button
import Ui.IconButton
import Ui.App
import Ui
import SObject


type alias Model =
    { app : Ui.App.Model
    , sobject : SObject.Model
    }


init : Model
init =
    { app = Ui.App.init "SOBS"
    , sobject = SObject.init "Unit__c"
    }


type Msg
    = App Ui.App.Msg
    | Obj SObject.Msg
    | Load
    | Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        App act ->
            let
                ( app, effect ) =
                    Ui.App.update act model.app
            in
                ( { model | app = app }, Cmd.map App effect )

        Obj msg ->
            let
                ( obj, effect ) =
                    SObject.update msg model.sobject
            in
                ( { model | sobject = obj }, Cmd.map Obj effect )

        Load ->
            let
                ( obj, effect ) =
                    SObject.update SObject.helpLoad model.sobject
            in
                ( { model | sobject = obj }, Cmd.map Obj effect )
        
        Change str ->
          ({ model | sobject = SObject.init str}, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Ui.App.view App
        model.app
        [ Ui.Container.column []
            [ Ui.title [] [ text "SObject Viewer" ]
            , Ui.textBlock " "
            , Html.a [ href "http://github.com/cdcarter/sobs" ] [ text "view on github" ]
            ]
        , Ui.Container.row [] 
          [ Html.input [ Html.Attributes.placeholder "ObjectName", Html.Events.onInput Change , Html.Events.onBlur Load] []
          
          ]
        , Ui.Container.row [] [ Html.App.map Obj (SObject.view model.sobject) ]
        ]


main =
    Html.App.program
        { init = ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

module Main exposing (..)

import Html exposing (div, span, strong, text)
import Html.Attributes exposing (href)
import Html.App
import Ui.Container
import Ui.Button
import Ui.IconButton
import Ui.App
import Ui
import Counter


type alias Model =
    { app : Ui.App.Model
    , counters : List IndexedCounter
    , uid : Int
    }


type alias IndexedCounter =
    { idx : Int
    , model : Counter.Model
    }


init : Model
init =
    { app = Ui.App.init "SOBS"
    , counters = []
    , uid = 0
    }


type Msg
    = App Ui.App.Msg
    | Insert
    | Remove
    | Modify Int Counter.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        App act ->
            let
                ( app, effect ) =
                    Ui.App.update act model.app
            in
                ( { model | app = app }, Cmd.map App effect )

        Insert ->
            ( { model | counters = model.counters ++ [ IndexedCounter model.uid (Counter.init 0) ], uid = model.uid + 1 }, Cmd.none )

        Remove ->
            ( { model | counters = List.drop 1 model.counters }, Cmd.none )

        Modify idx msg ->
            ( { model | counters = List.map (updateHelp idx msg) model.counters }, Cmd.none )


updateHelp : Int -> Counter.Msg -> IndexedCounter -> IndexedCounter
updateHelp targetIdx msg { idx, model } =
    IndexedCounter idx
        (if targetIdx == idx then
            Counter.update msg model
         else
            model
        )


view : Model -> Html.Html Msg
view model =
    Ui.App.view App
        model.app
        [ Ui.Container.column []
            [ Ui.title [] [ text "S3 Elm UI" ]
            , Ui.textBlock "This is the basic Elm counter demo. I have turned the counter into its own module, and included it twice. Components! I also am using the elm-ui library as a styling framework. The page is automatically compiled and pushed to amazon s3 by a codeship deploy and the serverless project. "
            , Html.a [ href "http://github.com/cdcarter/sobs" ] [ text "view on github" ]
            ]
        , Ui.Container.row [] (List.map viewIndexedCounter model.counters)
        , Ui.Container.row []
            [ (if List.length model.counters < 3 then
                Ui.Button.primary "Insert" Insert
               else
                text ""
              )
            , (if List.length model.counters > 0 then
                Ui.Button.primary "Remove" Remove
               else
                text ""
              )
            ]
        ]


viewIndexedCounter : IndexedCounter -> Html.Html Msg
viewIndexedCounter { idx, model } =
    Html.App.map (Modify idx) (Counter.view model)


main =
    Html.App.program
        { init = ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

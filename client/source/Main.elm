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
    , topCounter : Counter.Model
    , bottomCounter : Counter.Model
    }


type Msg
    = App Ui.App.Msg
    | Top Counter.Msg
    | Bottom Counter.Msg
    | Reset


init : Int -> Int -> Model
init top bottom =
    { app = Ui.App.init "SOBS"
    , topCounter = Counter.init top
    , bottomCounter = Counter.init bottom
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        App act ->
            let
                ( app, effect ) =
                    Ui.App.update act model.app
            in
                ( { model | app = app }, Cmd.map App effect )

        Top msg ->
            ( { model | topCounter = Counter.update msg model.topCounter }, Cmd.none )

        Bottom msg ->
            ( { model | bottomCounter = Counter.update msg model.bottomCounter }, Cmd.none )

        Reset ->
            ( { model | topCounter = Counter.init 0, bottomCounter = Counter.init 0 }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Ui.App.view App
        model.app
        [ Ui.Container.column []
            [ Ui.title [] [ text "S3 Elm UI" ]
            , Ui.textBlock "This is the basic Elm counter demo. I have turned the counter into its own module, and included it twice. Components! I also am using the elm-ui library as a styling framework. The page is automatically compiled and pushed to amazon s3 by a codeship deploy and the serverless project. "
            , Html.a [ href "http://github.com/cdcarter/sobs" ] [ text "view on github" ]
            ]
        , Ui.Container.row []
            [ Html.App.map Top (Counter.view model.topCounter)
            , Html.App.map Bottom (Counter.view model.bottomCounter)
            ]
        , Ui.Container.row []
            [ Ui.IconButton.primary "Reset" "ion-ios-refresh-outline" "left" Reset ]
        ]


main =
    Html.App.program
        { init = ( init 0 0, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

module Counter exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Ui.Container
import Ui.Button
import Ui


-- MODEL


type alias Model =
    { container : Ui.Container.Model
    , counter : Int
    , clicks : Int
    }


init : Int -> Model
init count =
    { counter = 0
    , clicks = 0
    , container =
        { direction = "ltr"
        , align = ""
        , compact = False
        }
    }



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            {model | counter = model.counter + 1, clicks = model.clicks + 1}

        Decrement ->
            {model | counter = model.counter - 1, clicks = model.clicks + 1}



-- VIEW


view : Model -> Html Msg
view model =
    Ui.Container.view model.container
        []
        [ Ui.Container.column []
            [ div []
                [ span [] [ text "Counter:" ]
                , strong [] [ text (toString model.counter) ]
                ]
            , Ui.Container.row []
                [ Ui.Button.primary "Decrement" Decrement
                , Ui.Button.primary "Increment" Increment
                ]
            , Ui.textBlock ("Clicked: " ++ (toString model.clicks))
            ]
        ]

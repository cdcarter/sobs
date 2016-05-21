module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "cats" "", Cmd.none )



-- UPDATE


type Msg
    = MorePlease
    | ChangeTopic String
    | GifGetSucceed String
    | GifGetFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        ChangeTopic newTopic ->
            ( Model newTopic "", Cmd.none )

        GifGetSucceed newUrl ->
            ( Model model.topic newUrl, Cmd.none )

        GifGetFail _ ->
            ( model, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform GifGetFail GifGetSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , img [ src model.gifUrl ] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , memeTopic "Cats" model
        , memeTopic "Hamburgers" model
        ]


memeTopic : String -> Model -> Html Msg
memeTopic name model =
    let
        isSelected =
            model.topic == name
    in
        label []
            [ br [] []
            , input [ type' "radio", checked isSelected, onCheck (\_ -> ChangeTopic name) ] []
            , text name
            ]

port module Main exposing (main)

import Animation exposing (backgroundColor)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border
import Element.Font
import Element.Lazy
import Html exposing (Html)
import Page.Home
import Route exposing (Route)
import Style
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing (Parser)


port pageChanged : () -> Cmd msg


type alias Model =
    { dimensions : Dimensions
    , page : Maybe Route
    , key : Browser.Navigation.Key
    }


type Msg
    = InitialViewport Browser.Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url
    | UrlRequest Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        InitialViewport { viewport } ->
            ( { model
                | dimensions =
                    Dimensions.init
                        { width = viewport.width
                        , height = viewport.height
                        }
              }
            , Cmd.none
            )

        WindowResized width height ->
            ( { model
                | dimensions =
                    Dimensions.init
                        { width = toFloat width
                        , height = toFloat height
                        }
              }
            , Cmd.none
            )

        UrlChanged url ->
            ( { model | page = Route.parse url }, pageChanged () )

        UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )


view : Model -> Browser.Document Msg
view ({ page } as model) =
    { title = Route.title page
    , body =
        [ mainView model
        ]
    }


mainView : Model -> Html Msg
mainView ({ page } as model) =
    (case page of
        Just (Route.Home { refId }) ->
            Page.Home.view { dimensions = model.dimensions, refId = refId }

        Nothing ->
            Element.text "Page not found!"
    )
        |> Element.layout []


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navigationKey =
    ( { dimensions =
            Dimensions.init
                { width = 0
                , height = 0
                }
      , page = Route.parse url
      , key = navigationKey
      }
    , Browser.Dom.getViewport
        |> Task.perform InitialViewport
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize WindowResized
        ]


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequest
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

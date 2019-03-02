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
import Html exposing (Html)
import Page.Home
import Route exposing (Route)
import Style exposing (fonts, palette)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing (Parser)
import View.Campfire


port pageChanged : () -> Cmd msg


type alias Model =
    { dimensions : Dimensions
    , page : Maybe Route
    , key : Browser.Navigation.Key
    , fireAnimation : View.Campfire.Model
    }


type Msg
    = InitialViewport Browser.Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url
    | UrlRequest Browser.UrlRequest
    | CampfireMsg View.Campfire.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        InitialViewport { viewport } ->
            ( { model
                | dimensions =
                    Dimensions.init
                        { width = viewport.width
                        , height = viewport.height
                        , device =
                            Element.classifyDevice
                                { height = round viewport.height
                                , width = round viewport.width
                                }
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
                        , device = Element.classifyDevice { height = height, width = width }
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

        CampfireMsg campfireMsg ->
            ( { model | fireAnimation = View.Campfire.update campfireMsg model.fireAnimation }, Cmd.none )


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
        Just Route.Home ->
            Element.column
                [ Element.height Element.fill
                , Element.alignTop
                , Element.centerX
                , Element.width (Element.fill |> Element.maximum 1000)
                ]
                [ (if model.dimensions |> Dimensions.isMobile then
                    Element.column

                   else
                    Element.row
                  )
                    [ Element.width Element.fill
                    , Background.gradient
                        { angle = 45
                        , steps =
                            [ Element.rgb255 5 46 123
                            , Element.rgb255 65 135 204
                            ]
                        }
                    , Element.width Element.fill
                    , Element.height Element.fill
                    ]
                    [ View.Campfire.view model.fireAnimation
                        |> Element.el
                            [ Element.width (Element.maximum 200 Element.fill)
                            , Element.alignTop
                            , Element.paddingEach { top = 120, right = 0, bottom = 0, left = 0 }
                            , Element.centerX
                            ]
                    , Page.Home.view model
                    ]
                ]

        Nothing ->
            Element.text "Page not found!"
    )
        |> Element.layout
            []


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url navigationKey =
    ( { dimensions =
            Dimensions.init
                { width = 0
                , height = 0
                , device = Element.classifyDevice { height = 0, width = 0 }
                }
      , page = Route.parse url
      , key = navigationKey
      , fireAnimation = View.Campfire.init
      }
    , Browser.Dom.getViewport
        |> Task.perform InitialViewport
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize WindowResized
        , View.Campfire.subscriptions model.fireAnimation |> Sub.map CampfireMsg
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

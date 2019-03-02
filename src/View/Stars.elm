module View.Stars exposing (Model, Msg, init, subscriptions, update, view)

import Color exposing (Color)
import Color.Generator
import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes as Attrs exposing (style)
import Particle exposing (Particle, lifetimePercent)
import Particle.System as System exposing (System)
import Random exposing (Generator)
import Random.Float as R exposing (normal, standardNormal)
import Svg exposing (Svg)
import Svg.Attributes as SAttrs
import View.Star


type alias Model =
    System Star


type alias Msg =
    System.Msg Star


subscriptions : Model -> Sub.Sub Msg
subscriptions system =
    System.sub [] identity system


init : Model
init =
    System.burst (starSystemGenerator |> Random.list 100)
        (System.init (Random.initialSeed 0))


update msg system =
    System.update msg system


type alias Star =
    { color : Color
    , radius : Float
    }


starGenerator : Generator Star
starGenerator =
    Random.map2 Star
        randomColor
        (normal 30 5)


randomColor : Generator Color
randomColor =
    Random.uniform ( 229, 204, 153 )
        [ ( 175, 158, 126 ) ]
        |> Random.map Color.fromRGB


starSystemGenerator : Generator (Particle Star)
starSystemGenerator =
    Particle.init starGenerator
        |> Particle.withLifetime (normal 50000 200000)
        |> Particle.withLocation locationGenerator
        |> Particle.withDirection (normal (degrees -12) (degrees 12))


type alias Point =
    { x : Float, y : Float }


locationGenerator : Generator Point
locationGenerator =
    Random.map2 Point
        (Random.float 0 4000)
        (Random.float 0 500)


view : Model -> Element msg
view system =
    System.view viewStar [] system
        |> Element.html
        |> Element.el
            [ Element.width Element.fill ]


viewStar : Particle Star -> Svg msg
viewStar particle =
    let
        { color, radius } =
            Particle.data particle

        lifetimePercent =
            Particle.lifetimePercent particle

        opacity =
            (((lifetimePercent |> Debug.log "percent") * 100000000) |> round |> modBy 10000 |> toFloat)
                / 10000
                |> Debug.log "result"
    in
    View.Star.view
        [ color
            |> Color.Generator.adjustSaturation (lifetimePercent * -10)
            |> Color.toHexString
            |> SAttrs.fill
        , SAttrs.transform ("scale(" ++ String.fromFloat (radius / 25) ++ ")")
        , SAttrs.height (String.fromFloat radius)
        , opacity |> String.fromFloat |> SAttrs.opacity
        ]

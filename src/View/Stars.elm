module View.Stars exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Color exposing (Color)
import Color.Generator
import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes as Attrs exposing (style)
import Particle exposing (Particle, lifetimePercent)
import Particle.System as System exposing (System)
import Random exposing (Generator)
import Random.Float as R exposing (normal, standardNormal)
import Svg exposing (Svg)
import Svg.Attributes as SAttrs


type alias Model =
    System Droplet


type alias Msg =
    System.Msg Droplet


subscriptions system =
    System.sub [] identity system



-- init : Dimensions -> Model


init =
    -- System.burst (Random.list 100 (Particle.init droplet))
    System.burst (waterEmitter |> Random.list 100)
        (System.init (Random.initialSeed 0))


update msg system =
    System.update msg system



-- emitters


type alias Droplet =
    { color : Color
    , radius : Float
    }


droplet : Generator Droplet
droplet =
    Random.map2 Droplet
        randomColor
        (normal 30 5)


randomColor : Generator Color
randomColor =
    Random.uniform ( 229, 204, 153 )
        [ ( 175, 158, 126 ) ]
        |> Random.map Color.fromRGB


{-| Emitters take the delta (in milliseconds )since the last update. This is so
you can emit the right number of particles. This emitter emits about 60
particles per second.
-}
waterEmitter : Generator (Particle Droplet)
waterEmitter =
    Particle.init droplet
        -- |> Particle.withLifetime (normal 0.01 1)
        |> Particle.withLifetime (normal 1000 10000)
        |> Particle.withLocation locationGenerator
        |> Particle.withDirection (normal (degrees -12) (degrees 12))



-- |> Particle.withSpeed (normal 0 0.01)
-- |> Particle.withGravity -2


type alias Point =
    { x : Float, y : Float }


locationGenerator : Generator Point
locationGenerator =
    Random.map2 Point
        -- (Random.constant 325)
        -- (Random.float 0 width)
        (Random.float 0 4000)
        -- (Random.float 300 350)
        -- (Random.float 490 510)
        (Random.float 0 500)



-- (Random.float 0 40)
-- (Random.constant 500)
-- views


view : Model -> Element msg
view system =
    System.view viewStar
        []
        system
        |> Element.html
        |> Element.el
            [ Element.width Element.fill
            ]


viewStar : Particle Droplet -> Svg msg
viewStar particle =
    let
        { color, radius } =
            Particle.data particle

        lifetimePercent =
            Particle.lifetimePercent particle
    in
    Svg.g []
        [ Svg.path
            [ SAttrs.d "M-5,0c1.632,0.215,3.659,0.44,4.079,0.81C-0.501,1.18-0.215,3.368,0,5C0.215,3.368,0.5,1.18,0.92,0.81 C1.34,0.44,3.368,0.215,5,0C3.368-0.215,1.34-0.44,0.92-0.81C0.5-1.18,0.215-3.368,0-5c-0.215,1.632-0.5,3.82-0.921,4.19 C-1.341-0.44-3.368-0.215-5,0z"
            , color
                |> Color.Generator.adjustSaturation (lifetimePercent * -10)
                |> Color.toHexString
                |> SAttrs.fill
            , SAttrs.transform ("scale(" ++ String.fromFloat (radius / 25) ++ ")")
            , SAttrs.height (String.fromFloat radius)

            -- , SAttrs.opacity "0.5"
            , lifetimePercent |> String.fromFloat |> SAttrs.opacity
            ]
            []
        ]

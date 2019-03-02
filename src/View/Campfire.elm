module View.Campfire exposing (Model, Msg, init, subscriptions, update, view)

import Browser
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


type alias Model =
    System Droplet


type alias Msg =
    System.Msg Droplet


subscriptions system =
    System.sub [ waterEmitter ] identity system


init =
    System.init (Random.initialSeed 0)


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
    Random.uniform "#FDB703"
        [ "#F96802"
        , "#FC9C02"
        ]
        |> Random.map Color.fromHexString
        |> Random.map (Result.withDefault (Color.fromRGB ( 200, 200, 200 )))


{-| Emitters take the delta (in milliseconds )since the last update. This is so
you can emit the right number of particles. This emitter emits about 60
particles per second.
-}
waterEmitter : Float -> Generator (List (Particle Droplet))
waterEmitter delta =
    Particle.init droplet
        |> Particle.withLifetime (normal 0.01 1)
        |> Particle.withLocation locationGenerator
        -- |> Particle.withLocation (Random.constant { x = 325, y = 500 })
        |> Particle.withDirection (normal (degrees -12) (degrees 12))
        -- |> Particle.withSpeed (normal 100 30)
        |> Particle.withSpeed (normal 0 1)
        |> Particle.withGravity -10
        |> Random.list (ceiling (delta * (60 / 1000)))


type alias Point =
    { x : Float, y : Float }


locationGenerator : Generator Point
locationGenerator =
    Random.map2 Point
        -- (Random.constant 325)
        (Random.float 80 130)
        -- (Random.float 300 350)
        -- (Random.float 490 510)
        (Random.float 30 40)



-- (Random.constant 500)
-- views


view : Model -> Element msg
view system =
    System.view viewDroplet
        []
        system
        |> Element.html
        |> Element.el
            [ Element.width Element.fill
            , log1 |> Element.inFront
            , log2 |> Element.inFront
            ]


log1 : Element msg
log1 =
    Html.div
        [ Attrs.style "position" "absolute"
        , Attrs.style "content" ""
        , Attrs.style "top" "100px"
        , Attrs.style "left" "100px"
        , Attrs.style "transform" "translate(-50%, -50%) rotate(25deg)"
        , Attrs.style "height" "40px"
        , Attrs.style "width" "180px"
        , Attrs.style "border-radius" "1vw"
        , Attrs.style "background-color" "#70392F"
        ]
        []
        |> Element.html


log2 : Element msg
log2 =
    Html.div
        [ Attrs.style "position" "absolute"
        , Attrs.style "content" ""
        , Attrs.style "top" "100px"
        , Attrs.style "left" "100px"
        , Attrs.style "transform" "translate(-50%, -50%) rotate(-25deg)"
        , Attrs.style "height" "40px"
        , Attrs.style "width" "180px"
        , Attrs.style "border-radius" "1vw"
        , Attrs.style "background-color" "#70392F"
        ]
        []
        |> Element.html


viewDroplet : Particle Droplet -> Svg msg
viewDroplet particle =
    let
        { color, radius } =
            Particle.data particle

        lifetimePercent =
            Particle.lifetimePercent particle
    in
    Svg.rect
        [ SAttrs.width (String.fromFloat radius)
        , SAttrs.height (String.fromFloat radius)
        , SAttrs.transform "rotate(45)"
        , color
            |> Color.Generator.adjustSaturation (lifetimePercent * -10)
            |> Color.toHexString
            |> SAttrs.fill
        ]
        []


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
            ]
            []
        ]

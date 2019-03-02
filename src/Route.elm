module Route exposing (Route(..), parse, title, toUrl)

import Url.Builder
import Url.Parser exposing ((</>), Parser, s)


type Route
    = Home


toUrl route =
    (case route of
        Home ->
            []
    )
        |> (\path -> Url.Builder.absolute path [])


title : Maybe Route -> String
title maybeRoute =
    maybeRoute
        |> Maybe.map
            (\route ->
                case route of
                    Home ->
                        "Elm Camp"
            )
        |> Maybe.withDefault "elm-camp - Page not found"


parse url =
    url
        |> Url.Parser.parse parser


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        ]

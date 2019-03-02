module Route exposing (Route(..), parse, title, toUrl)

import Url.Builder
import Url.Parser exposing ((</>), Parser, s)
import Url.Parser.Query


type Route
    = Home { refId : Maybe String }


toUrl route =
    (case route of
        Home _ ->
            []
    )
        |> (\path -> Url.Builder.absolute path [])


title : Maybe Route -> String
title maybeRoute =
    maybeRoute
        |> Maybe.map
            (\route ->
                case route of
                    Home _ ->
                        "Elm Camp"
            )
        |> Maybe.withDefault "elm-camp - Page not found"


parse url =
    url
        |> Url.Parser.parse parser


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map (\refId -> Home { refId = refId }) (Url.Parser.Query.string "ref" |> Url.Parser.query)
        ]

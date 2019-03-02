module TestMarkup exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Page.Home
import Test exposing (..)


suite : Test
suite =
    test "markup is valid" <|
        \() ->
            Page.Home.parsedMarkup
                |> Expect.ok

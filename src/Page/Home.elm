module Page.Home exposing (parsedMarkup, view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Border
import Element.Font
import Html
import Html.Attributes exposing (attribute, class, style)
import Mark
import MarkParser
import Style exposing (fontSize, fonts, palette)
import View.FontAwesome


view : { dimensions : Dimensions, refId : Maybe String } -> Element.Element msg
view model =
    parsedMarkup
        |> (\result ->
                case result of
                    Err message ->
                        Element.text "Failed to parse."

                    Ok element ->
                        element model
           )


parsedMarkup =
    markupBody
        |> Mark.parse MarkParser.document


markupBody : String
markupBody =
    """| Title
    Who wants to go to Elm Camp?!

Interested in spending 3 days with the creators of Elm GraphQL and Elm UI?

The Masterclass workshops will cover:

| List
    - Type-safety and flexibility across APIs with Elm GraphQL
    - Unrivaled styling experience with Elm UI
    - Incremental techniques for adopting these libraries for your codebase
    - Best practices you can’t learn from just browsing the docs


We want to give you so many practical, implementable techniques that you're a :rocketship: with your typesafe app.  This'll cover the best practices we've encountered.

We're limiting this event to 25 people so you get the most one-on-one time possible and connect with everyone there.  It'll be like going to summer camp!


| Header
    The Organizers

| Trainers
    | Trainer
        name = Matt Griffith
        imageUrl = /assets/matt.jpg
        bio = Author of elm-ui, elm-markup, elm-style-animation, and Why Elm.

    | Trainer
        name = Dillon Kearns
        imageUrl = /assets/dillon.jpg
        bio = Author of elm-graphql. He’s the founder of Incremental Elm where he helps teams master elm techniques without finding them the hard way.
    | Trainer
        name = Dan Abrams
        imageUrl = /assets/dan.jpg
        bio = Co-organizer of elm Europe. Author of elm-media.

| SignupBox
    | Header
        Stay Informed About Elm Camp
    | List
        - Official date and location announcement
        - Early bird ticket sale

    We’ll also notify you of our live coding streams that will give you a preview of some of the techniques you’ll learn at elm-camp:
    | List
        - Underused best practices for elm-ui and elm-graphql
        - Common problems and solutions in elm-ui and elm-graphql"""

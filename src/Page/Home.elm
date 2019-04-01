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

It'll be a masterclass workshop covering

| List
    - Type-safety and flexibility across APIs with Elm GraphQL
    - Unrivaled styling experience with Elm UI
    - Incremental techniques for adopting these libraries for your codebase
    - Best practices you can’t learn from just browsing the docs


We want to give you so many practical, implementable techniques that you're a :rocketship: with your typesafe app.  This'll cover the best practices we've encountered.

We're limiting this event to 25 people so you get the most one-on-one time possible and connect with everyone there.  It'll be like going to summer camp!


| Header
    The Organizers

| Trainer
    name = Matt Griffith
    imageUrl = /assets/matt.jpg
    bio = Matt is the author of the popular Elm UI library. Elm UI is known for making it as delightful to create your views as it is to write any other Elm code. More impressively, it even makes refactoring and changing your views delightful and reliable!

| Trainer
    name = Dillon Kearns
    imageUrl = /assets/dillon.jpg
    bio = As the founder of Incremental Elm Consulting, Dillon's mission is to train elm teams on techniques to write elm code like experts, so they don't have to learn the hard way. Dillon introduced elm at a Fortune 10 company and trained several teams to adopt it for their front ends. The maintainability and reduced bugs inspired him to help more teams succeed with elm. In his free time he loves backpacking and playing piano
| Trainer
    name = Dan Abrams
    imageUrl = /assets/dan.jpg
    bio = Dan is an elm developer who started his career as a screenwriter. He has written for film, tv, and video games. Dan lives in northern NJ with his fianceé and their dog, and just finished a batch at Recurse Center.


<>

| Signup
"""

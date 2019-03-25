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
                        -- Element.text "Failed to parse."
                        message |> Debug.toString |> Element.text |> List.singleton |> Element.paragraph []

                    Ok element ->
                        element model
           )


parsedMarkup =
    markupBody
        |> Mark.parse MarkParser.document


markupBody : String
markupBody =
    """| Title
    elm-camp

You love Elm. It lets you change your code fearlessly! But...
| List
    - Did that CSS you added actually do anything?
    - Did it /break something totally unrelated/?
    - Did your API change break a JSON Decoder?

Imagine if changing your API requests and styling was as bulletproof and easy as changing the rest of your Elm app!

| Header
    Who Is elm-camp For?

elm-camp is a great fit for you if you are:
| List
    - Comfortable with Elm basics, but looking to level up.

| Header
    Master The Libraries That Make Elm /Even More Elm/

elm-camp is a 3-day hands-on training retreat where you'll master elm-ui and elm-graphql. You'll come away with a full grasp of both libraries' fundamentals and best practices, as taught by the library authors themselves.

| Header
    Schedule

| Subheader
    Day 1

elm-ui Masterclass by Matthew Griffith

{Link|>> Learn more about elm-ui.| url = https://www.youtube.com/watch?v=Ie-gqwSHQr0 }

| Subheader
    Day 2

elm-graphql Masterclass by Dillon Kearns

{Link|>> Learn more about elm-graphql. | url = https://www.youtube.com/watch?v=memIRXFSNkU }

| Subheader
    Day 3

| Header
    Be the First to Know!

There are limited seats! If you sign up here, you'll be the first to know when you can get your tickets, and we'll give you a special discount as thanks for showing your enthusiasm!

<>

| Signup

<>

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

| SocialBadges
    | Badge
        url = https://twitter.com/elmcamp
        icon = fab fa-twitter
    | Badge
        url = https://github.com/elm-camp/elm-camp-web
        icon = fab fa-github
    | Badge
        url = https://www.linkedin.com/groups/13683764/
        icon = fab fa-linkedin-in
"""

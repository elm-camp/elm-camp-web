module Page.Home exposing (parsedMarkup, view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
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
    """| Navbar
    | Title
        elm-camp
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

You love Elm. It lets you change your code fearlessly! Until...
| List
    - You need to reload that page to see if the CSS you tweaked actually did anything (or *broke something else*).
    - You run through your app only to find that your JSON Decoder mysterisouly stopped working.

The /elm/ part of elm is great. If only changing your app's API and styling were that easy!

| Header
    Master The Libraries That Make Elm /Even More Elm/

elm-camp is a 3-day hands-on training retreat where you'll master the libraries that *Make Elm Even More Elm*: elm-ui and elm-graphql. You'll learn the fundamentals and best practices from the library authors themselves.

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
"""

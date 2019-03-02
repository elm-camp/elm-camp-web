module View.SignupForm exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)


view : Maybe String -> Html msg
view maybeReferenceId =
    div [ id "mc_embed_signup" ]
        [ Html.form
            [ action "https://elm-camp.us20.list-manage.com/subscribe/post?u=2ea5c30f7f26d370b6b4bb717&amp;id=94d56d9a7a"
            , method "post"
            , id "mc-embedded-subscribe-form"
            , name "mc-embedded-subscribe-form"
            , class "validate"
            , target "_blank"
            , novalidate True
            ]
            [ div [ id "mc_embed_signup_scroll", Attr.style "display" "flex" ]
                [ fieldGroup { name = "EMAIL", display = "Email Address" }
                , fieldGroup { name = "FNAME", display = "First Name" }
                , fieldGroup { name = "LNAME", display = "Last Name" }
                , fieldGroup_ { hidden = True, defaultValue = maybeReferenceId, display = "Reference ID", name = "REFERENCE" }
                ]
            , closingContents
            , div [ attribute "aria-hidden" "true", attribute "style" "position: absolute; left: -5000px;" ]
                [ input [ name "b_2ea5c30f7f26d370b6b4bb717_94d56d9a7a", attribute "tabindex" "-1", type_ "text", value "" ]
                    []
                ]
            , div [ class "clear" ]
                [ submitButton
                ]
            ]
        ]


fieldGroup : { display : String, name : String } -> Html msg
fieldGroup values =
    fieldGroup_
        { hidden = False
        , defaultValue = Nothing
        , display = values.display
        , name = values.name
        }


fieldGroup_ : { hidden : Bool, defaultValue : Maybe String, display : String, name : String } -> Html msg
fieldGroup_ options =
    div
        [ class "mc-field-group"
        , if options.hidden then
            style "display" "none"

          else
            style "margin-top" "10px"
        ]
        [ label [ for <| "mce-" ++ options.name ] [ text options.display ]
        , div [] []
        , input
            [ type_ "email"
            , options.defaultValue |> Maybe.withDefault "" |> value
            , name options.name
            , id <| "mce-" ++ options.name
            , style "appearance" "none"
            , style "-webkit-appearance" "none"
            , style "-moz-appearance" "none"
            , style "border-radius" "4px"
            , style "border" "2px solid #d0d0d0"
            , style "padding-top" "10px"
            , style "padding-left" "10px"
            , style "padding-right" "10px"
            , style "font-family" "Raleway"
            , style "font-size" "20px"
            , style "margin-top" "10px"
            ]
            []
        ]


closingContents =
    div [ class "clear", id "mce-responses" ]
        [ div [ class "response", id "mce-error-response", attribute "style" "display:none" ]
            []
        , div [ class "response", id "mce-success-response", attribute "style" "display:none" ]
            []
        ]


submitButton : Html msg
submitButton =
    input
        [ class "button"
        , id "mc-embedded-subscribe"
        , name "subscribe"
        , type_ "submit"
        , value "Keep Me Posted!"
        , style "font-size" "18px"
        , style "font-family" "Open Sans"
        , style "margin-top" "10px"
        , style "width" "220px"
        , style "height" "55px"
        ]
        []

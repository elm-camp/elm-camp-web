module MarkParser exposing (document)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html.Attributes
import Mark exposing (Document)
import Mark.Default
import Style
import View.SignupForm
import View.Trainer


document : Mark.Document ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
document =
    let
        defaultText =
            Mark.Default.textWith Mark.Default.defaultTextStyle
    in
    Mark.document
        (\children model ->
            Element.textColumn
                [ Element.width Element.fill
                , Element.centerX
                , Element.spacing 30
                , Element.padding 35
                ]
                (List.map (\view -> view model) children)
        )
        (Mark.manyOf
            [ Mark.Default.header
                [ Font.size 36
                , Font.family [ Font.typeface "Asap Condensed" ]
                , Font.center
                , Font.color (Element.rgb255 255 255 255)
                ]
                defaultText
            , Mark.Default.title
                [ Element.padding 30
                , Element.centerX
                , Font.color (Element.rgb255 240 240 240)
                , Style.fontSize.title
                , Style.fonts.title
                , Font.center
                , Element.width Element.fill
                , Font.family [ Font.typeface "Asap Condensed" ]
                ]
                defaultText
            , Mark.Default.list
                { style = listStyles
                , icon = Mark.Default.listIcon
                }
                defaultText
            , image
            , trainer
            , signup
            , Mark.Default.monospace
                [ Element.spacing 5
                , Element.padding 24
                , Background.color
                    (Element.rgba 0 0 0 0.04)
                , Border.rounded 2
                , Font.size 16
                , Style.fonts.code
                , Font.alignLeft
                ]

            -- Toplevel Text
            , Mark.map
                (\viewEls model ->
                    Element.paragraph
                        [ Font.family [ Font.typeface "Montserrat" ]
                        , Font.color (Element.rgb255 255 255 255)
                        , Font.size 16
                        ]
                        (viewEls model)
                )
                defaultText
            ]
        )


image : Mark.Block (model -> Element msg)
image =
    Mark.record2 "Image"
        (\src description model ->
            Element.image
                [ Element.width (Element.fill |> Element.maximum 600)
                , Element.centerX
                ]
                { src = src
                , description = description
                }
                |> Element.el [ Element.centerX ]
        )
        (Mark.field "src" Mark.string)
        (Mark.field "description" Mark.string)


trainer : Mark.Block ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
trainer =
    Mark.record3 "Trainer"
        (\name imageUrl bio model ->
            View.Trainer.view (Dimensions.isMobile model.dimensions) { name = name, imageUrl = imageUrl, bio = bio }
        )
        (Mark.string |> Mark.field "name")
        (Mark.string |> Mark.field "imageUrl")
        (Mark.string |> Mark.field "bio")


signup : Mark.Block ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
signup =
    Mark.stub "Signup"
        (\model ->
            View.SignupForm.view model.refId |> Element.html
        )


listStyles : List Int -> List (Element.Attribute msg)
listStyles cursor =
    (case List.length cursor of
        0 ->
            -- top level element
            [ Element.spacing 16 ]

        1 ->
            [ Element.spacing 16 ]

        2 ->
            [ Element.spacing 16 ]

        _ ->
            [ Element.spacing 8 ]
    )
        ++ [ Font.alignLeft ]

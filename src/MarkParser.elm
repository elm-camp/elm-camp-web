module MarkParser exposing (document)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html.Attributes
import Mark exposing (Document)
import Mark.Default exposing (defaultTextStyle)
import Style
import View.FontAwesome
import View.SignupForm
import View.Trainer


primaryColor : Element.Color
primaryColor =
    Element.rgb255 0 0 0


highlightColor : Element.Color
highlightColor =
    Element.rgb255 253 183 3


defaultText : Mark.Block (model -> List (Element msg))
defaultText =
    Mark.Default.textWith
        { defaultTextStyle
            | link =
                [ Font.color primaryColor
                , Font.underline
                , Element.mouseOver
                    [ Font.color highlightColor
                    ]
                ]
        }


document : Mark.Document ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
document =
    Mark.document
        (\children model ->
            Element.textColumn
                [ Element.spacing 30
                , Element.padding 35
                , Element.centerX
                , Element.width (Element.fill |> Element.maximum 1200)
                ]
                (List.map (\view -> view model) children)
        )
        (Mark.manyOf
            [ header
            , trainers
            , subheader
                [ Font.size 24
                , Font.alignLeft
                , Font.family [ Font.typeface "Asap Condensed" ]
                , Font.color primaryColor
                ]
                defaultText
            , title
            , list
            , image
            , signupBox
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
            , topLevelText
            ]
        )


header : Mark.Block (model -> Element msg)
header =
    Mark.Default.header
        [ Font.size 36
        , Font.family [ Font.typeface "Asap Condensed" ]
        , Font.center
        , Font.color primaryColor
        ]
        defaultText


subheader : List (Element.Attribute msg) -> Mark.Block (model -> List (Element msg)) -> Mark.Block (model -> Element msg)
subheader attrs textParser =
    Mark.block "Subheader"
        (\elements model ->
            Element.paragraph
                (Element.Region.heading 3 :: attrs)
                (elements model)
        )
        textParser


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


trainer : Mark.Block (Element msg)
trainer =
    Mark.record3 "Trainer"
        (\name imageUrl bio ->
            View.Trainer.view
                { name = name
                , imageUrl = imageUrl
                , bio = bio ()
                }
        )
        (Mark.string |> Mark.field "name")
        (Mark.string |> Mark.field "imageUrl")
        (Mark.field "bio" defaultText)


trainers : Mark.Block ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
trainers =
    Mark.block "Trainers"
        (\children model ->
            if Dimensions.isMobile model.dimensions then
                Element.column [] children

            else
                Element.row [] children
        )
        (Mark.manyOf [ trainer ])


signupBox : Mark.Block ({ model | dimensions : Dimensions, refId : Maybe String } -> Element msg)
signupBox =
    Mark.block "SignupBox"
        (\children model ->
            Element.textColumn
                [ Element.centerX
                , Element.spacing 30
                , Element.padding 35
                , Element.width Element.fill
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 1
                    , blur = 1
                    , color = Element.rgba255 0 0 0 0.35
                    }
                , Background.color (Element.rgba255 170 210 250 0.2)
                ]
                (List.map (\child -> child model) children
                    ++ [ View.SignupForm.view model.refId |> Element.html ]
                )
        )
        (Mark.manyOf
            [ list
            , topLevelText
            , header
            ]
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
        ++ [ Font.alignLeft
           , Font.family [ Font.typeface "Montserrat" ]
           , Font.color primaryColor
           , Font.size 16
           , Element.width Element.fill
           ]


title : Mark.Block (model -> Element msg)
title =
    Mark.Default.title
        [ Element.padding 30
        , Font.color primaryColor
        , Style.fontSize.title
        , Style.fonts.title
        , Font.center
        , Font.family [ Font.typeface "Asap Condensed" ]
        ]
        defaultText


list : Mark.Block (model -> Element msg)
list =
    Mark.Default.list
        { style = listStyles
        , icon = Mark.Default.listIcon
        }
        defaultText


topLevelText =
    Mark.map
        (\viewEls model ->
            Element.paragraph
                [ Font.family [ Font.typeface "Montserrat" ]
                , Font.color primaryColor
                , Font.size 16
                ]
                (viewEls model)
        )
        defaultText

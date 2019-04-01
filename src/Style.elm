module Style exposing (animationPalette, bodyAttrs, color, elementRgb, fontSize, fonts, headerAttrs, highlightFactor, highlightRgb, hoverPalette, palette, rgb, shadow)

import Animation
import Element
import Element.Border
import Element.Font


bodyAttrs =
    [ Element.Font.family [ Element.Font.typeface "Montserrat" ]
    , Element.Font.color (Element.rgba255 0 0 0 0.85)
    , Element.Font.size 16
    ]


headerAttrs =
    [ Element.Font.size 24
    , Element.Font.family [ Element.Font.typeface "Asap Condensed" ]
    , Element.Font.color (Element.rgb255 0 0 0)
    ]


fonts =
    { title = Element.Font.family [ Element.Font.typeface "Asap Condensed" ]
    , body = Element.Font.family [ Element.Font.typeface "Raleway" ]
    , code = Element.Font.family [ Element.Font.typeface "Roboto Mono" ]
    }


fontSize =
    { body = Element.Font.size 20
    , title = Element.Font.size 60
    , smallTitle = Element.Font.size 30
    , quotation = Element.Font.size 100
    , medium = Element.Font.size 16
    , small = Element.Font.size 14
    , logo = Element.Font.size 24
    }


color =
    palette


shadow =
    Element.Border.shadow { offset = ( 2, 1 ), size = 1, blur = 4, color = Element.rgb 0.8 0.8 0.8 }


palette =
    { main = elementRgb 216 219 226
    , bold = elementRgb 0 23 31
    , light = elementRgb 0 126 167
    , highlight = elementRgb 0 168 232
    , mainBackground = elementRgb 255 255 255
    , highlightBackground = elementRgb 0 52 89
    }


hoverPalette =
    { main = highlightRgb 216 219 226
    , bold = highlightRgb 0 23 31
    , light = highlightRgb 0 126 167
    , highlight = highlightRgb 0 168 232
    , mainBackground = highlightRgb 255 255 255
    , highlightBackground = highlightRgb 0 52 89
    }


highlightFactor =
    25


highlightRgb red green blue =
    elementRgb (red + highlightFactor) (green + highlightFactor) (blue + highlightFactor)


elementRgb red green blue =
    Element.rgb (red / 255) (green / 255) (blue / 255)


rgb : Int -> Int -> Int -> Animation.Color
rgb red green blue =
    { red = red
    , green = green
    , blue = blue
    , alpha = 1.0
    }


animationPalette =
    { main = rgb 216 219 226
    , bold = rgb 0 23 31
    , light = rgb 0 126 167
    , highlight = rgb 0 168 232
    , mainBackground = rgb 255 255 255
    , highlightBackground = rgb 0 52 89
    }

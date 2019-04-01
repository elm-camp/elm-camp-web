module View.Trainer exposing (view)

import Element
import Style


view isMobile details =
    Element.row
        [ Element.centerX
        ]
        [ avatar details
        , bio details
        ]


bio details =
    Element.column
        [ Element.padding 20
        , Element.height Element.fill
        , Element.spacing 15
        , Element.width Element.fill
        ]
        [ [ Element.text details.name ] |> Element.paragraph Style.headerAttrs

        -- , [ Element.text details.bio ] |> Element.paragraph Style.bodyAttrs
        , Element.paragraph Style.bodyAttrs details.bio
        ]


avatar details =
    Element.image [ Element.width (Element.fill |> Element.maximum 120), Element.centerX ]
        { src = details.imageUrl
        , description = details.name
        }

module View.Trainer exposing (avatar, view)

import Element
import Style


view details =
    Element.row
        [ Element.alignLeft
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
        , [ Element.text details.bio ] |> Element.paragraph Style.bodyAttrs
        ]


avatar details =
    Element.image [ Element.width (Element.fill |> Element.maximum 250), Element.centerX ]
        { src = details.imageUrl
        , description = details.name
        }

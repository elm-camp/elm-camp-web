module View.Trainer exposing (view)

import Element
import Element.Font
import Style


view details =
    Element.column
        [ Element.centerX
        , Element.alignTop
        , Element.width Element.fill

        -- , Element.explain Debug.todo
        ]
        [ avatar details
        , bio details
        ]


bio details =
    Element.column
        [ Element.padding 20
        , Element.spacing 15
        , Element.width Element.fill
        ]
        [ [ Element.text details.name ] |> Element.paragraph (Element.Font.center :: Style.headerAttrs)

        -- , [ Element.text details.bio ] |> Element.paragraph Style.bodyAttrs
        , Element.paragraph Style.bodyAttrs details.bio
        ]


avatar details =
    Element.image [ Element.width (Element.fill |> Element.maximum 120), Element.centerX ]
        { src = details.imageUrl
        , description = details.name
        }

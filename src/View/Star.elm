module View.Star exposing (view)

import Html exposing (Html)
import Svg
import Svg.Attributes as SAttrs


view : List (Svg.Attribute msg) -> Html msg
view additionalAttributes =
    Svg.g []
        [ Svg.path
            (SAttrs.d "M-5,0c1.632,0.215,3.659,0.44,4.079,0.81C-0.501,1.18-0.215,3.368,0,5C0.215,3.368,0.5,1.18,0.92,0.81 C1.34,0.44,3.368,0.215,5,0C3.368-0.215,1.34-0.44,0.92-0.81C0.5-1.18,0.215-3.368,0-5c-0.215,1.632-0.5,3.82-0.921,4.19 C-1.341-0.44-3.368-0.215-5,0z"
                :: additionalAttributes
            )
            []
        ]

module Sliders exposing (main)

import Browser
import Html
import Ui exposing (..)
import Ui.Input as Input


type alias Model =
    { value : Float }


initialModel : Model
initialModel =
    { value = 50 }


type Msg
    = UserChangedSlider Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserChangedSlider value ->
            { model | value = value }


view : Model -> Html.Html Msg
view model =
    layout default [] <|
        column [ padding 20, spacing 30, width <| px 400 ]
            [ let
                label : { element : Element msg, id : Input.Label }
                label =
                    Input.label "Default slider"
                        []
                        (text "Default slider")
              in
              row [ spacing 10 ]
                [ Input.sliderHorizontal []
                    { label = label.id
                    , max = 100
                    , min = 0
                    , onChange = UserChangedSlider
                    , step = Nothing
                    , thumb = Nothing
                    , value = model.value
                    }
                , label.element
                ]
            , let
                label : { element : Element msg, id : Input.Label }
                label =
                    Input.label "Slider moved 8 px up"
                        []
                        (text "Slider moved 8 px up")
              in
              row [ spacing 10 ]
                [ Input.sliderHorizontal []
                    { label = label.id
                    , max = 100
                    , min = 0
                    , onChange = UserChangedSlider
                    , step = Nothing
                    , thumb = Just (thumb 8)
                    , value = model.value
                    }
                , label.element
                ]
            ]


thumb : Int -> Input.Thumb msg
thumb moved =
    let
        colorBackground : Color
        colorBackground =
            rgb 255 255 255

        colorBorder : Color
        colorBorder =
            rgba 0 0 0 0.4

        track : Color
        track =
            rgb 50 200 100
    in
    Input.thumbWith
        { higherTrack =
            [ height (px 8)
            , rounded 8
            , border 1
            , borderColor colorBorder
            , background colorBackground
            , widthMin 8
            ]
        , lowerTrack =
            [ height (px 8)
            , rounded 8
            , border 1
            , borderColor colorBorder
            , background track
            , widthMin 8
            ]
        , thumb =
            [ width (px 16)
            , height (px 16)
            , rounded 8
            , border 1
            , borderColor colorBorder
            , background colorBackground

            -- This fix a weird issue in Chrome, but introduce an issue in Safari/Firefox
            -- https://www.notion.so/25d2ac32de2980ad8f91c175cd1f84d5?v=25d2ac32de2980588787000ce0b324be
            , move <| up moved
            ]
        }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }

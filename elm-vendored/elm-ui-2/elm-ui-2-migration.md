# Migration notes from elm-ui 1.x to elm-ui 2.0

## Clone and copy the content of the `src` folders of these two repos in your project

```
https://github.com/mdgriffith/elm-ui/tree/2.0
https://github.com/mdgriffith/elm-animator/tree/v2
```

Get the code from the branches `2.0` for `elm-ui`, and `v2` for `elm-animator`.

Copy these in your project, for example under

```
elm-vendored/elm-ui-2/src
elm-vendored/elm-animator-2/src
```

Add these two folders in the `source-directories` section of `elm.json`.

## Install elm-color if not already installed

```
elm-json install avh4/elm-color
```

## Ui.radians conflict

`radians` is exposed by 2 of the imports:

```
Basics.radians
Ui.radians
```
     
If you import it like

```
import Ui exposing (..)
```

you still need to prefix `radians` as `Ui.radians` to avoid the conflict.

## Import replaces

* From `import Element exposing (..)` to `import Ui exposing (..)`
* From `import Element.Events as Events` to `import Ui.Events as Events`
* From `import Element.Font as Font` to `import Ui.Font as Font`
* From `import Element.Input as Input` to `import Ui.Input as Input`

## Import removals

* `import Element.Background as Background`
* `import Element.Border as Border`
 
## Import additions

* `import Ui.Prose as Prose` (for `paragraph`)
* `import Color` (When color management is needed)
* `import Ui.Shadow as Shadow`

## Colors

* Replace `rgb255` with `rgb`
* Convert floating colors to integers multipling by 255 (e.g. 0.8 = 0.8 * 255 = 204)
* Replace `rgb 1 1 1` with `rgb 255 255 255`
* Replace `rgba 1 1 1` with `rgba 255 255 255`

## Borders

* Replace `Border.width` with `border`
* Replace `Border.shadow` with `Shadow.shadows`
* Replace the `Shadow.shadows` argument from `{ blur = 12, color = rgba 0 0 0 0.15, offset = ( 0, -2 ), size = 0 }` to
` [ { blur = 12, color = rgba 0 0 0 0.15, size = 0, x = 0, y = -2 } ]` (note the added list and the decomposition of `offset` to `x` and `y`.
* Replace `Border.widthEach` with `borderWith`
* Replace `Border.color` with `borderColor`
* Replace `Border.rounded` with `rounded`

## Background

* Replace `Background.color` to `background`.

Note that `border` set the width, while `background` set the color. To set the color for a border, use `borderColor`.

## `move`s

* Replace `moveDown 4` to `move <| down 4`. Also convert the argument to `Int` using `round` or removing `toFloat`
* The same for `moveUp`, `moveLeft`, `moveRight`
* Multiple `move` do not compose in v2, but they were composing in v1. To compose them in v2, call them as `move { x=0, y=0, z=0 }`
* Note that in v1 move was using CSS `tranformation`, while in v2 is using CSS `translation`. So if you use CSS transition you need to do something like `transition: translate 150ms ease-out`.

## Buttons

* Replace `Input.button` with `el`
* Move `Input.button` among the attributes, taking the message for the `onPress` value (without the `Maybe`)
* Remove the record `{ label = ..., onPress = ... }` with just the content of the label.

### AS IS

```
Input.button 
    [ height <| px 20 ]
    { label = el [ centerX, centerY ] <| html "Back"
    , onPress = Just UserPressedBackButton
    }
```

### TO BE

```
el
    [ height <| px 20
    , Input.button UserPressedBackButton
    ]
    (el [ centerX, centerY ] <| html "Back")
```

## `width` attribute

* Most (if not all) `width fill` are unnecessary now.
* Some new `width shrink` may became necessary here and there.
* Some new `height fill` may became necessary, for example in case of `inFront`.

### AS IS

`width <| maximum (500) <| fill`

### TO BE

`widthMax 500`

## `mouseOver`

This doesn't have an immediate replacement.

It can be replaced with `Ui.Anim.onHover` but I haven't look into it yet.

## Labels of input fields

Labels are handled differently in V2. They are created separately and added using the usual `row`, `column` approach.

For example:

```
f =
    let
        label : { element : Element msg, id : Input.Label }
        label =
            Input.label "client-id"
                [ Font.size 12, width shrink ]
                (text "Client ID")
    in
    row 
        [ spacing 8 ]
        [ label.element
        , Input.text [ Font.size 12, padding 5 ]
            { label = label.id
            , onChange = UserChangedClientId
            , placeholder = Nothing
            , text = model.clientId
            }
        ]
```
## `wrappedRow`

`wrappedRow` seems to be replaceable with

```
row [ wrap ] ...
```

## Font weights

* Replace `Font.heavy` with `Font.weight 900`
* Replace `Font.extraBold` with `Font.weight 800`
* Replace `Font.bold` with `Font.weight 700`
* Replace `Font.semiBold` with `Font.weight 600`
* Replace `Font.medium` with `Font.weight 500`
* Replace `Font.regular` with `Font.weight 400`
* Replace `Font.light` with `Font.weight 300`
* Replace `Font.extraLight` with `Font.weight 200`
* Replace `Font.hairline` with `Font.weight 100`

## Others

* Replace `alpha` with `opacity`
* Replace `layout` with `layout default`
* Replace `layoutWith` with `layout`. Note that the options are different now.

## Issues reporting

Report issues at https://www.notion.so/25d2ac32de2980ad8f91c175cd1f84d5?v=25d2ac32de2980588787000ce0b324be

## Reduction of assets

elm-ui V2 seem introducing a reduction of assets size (around 5%)

These are some values from a small Elm project:

```
7,819 lines of Elm code

elm-ui 1.1.8

240,627 bytes minified
 63,802 bytes compressed
 
elm-ui 2.0

215,350 bytes minified
 59,495 bytes compressed

-10.5 % minified
 -6.8 % compressed

================

10,662 lines of Elm code

elm-ui 1.1.8

517,358 bytes minified
120,421 bytes compressed

elm-ui 2.0

484,203 bytes minified
114,305 bytes compressed

-6.4 %
-5.1 %
```
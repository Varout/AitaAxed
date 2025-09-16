# AitaAxed

**Contents**

- [About](#about)
- [Settings.xml](#settingsxml)
- [Commands](#commands)
- [Known Issues](#known-issues)
- [Links](#links)
- [Copyright](#copyright)

## About

Check out [releases](https://github.com/Varout/AitaAxed/releases) for the latest version.

AitaAxed came about as a more visual solution that doesn't rely on the chat log and React, when fighting specific bosses in Sortie. Someone suggested using React to print out to the log, however I'm either always looking at my party's HP numbers (while on WHM) or at my skillchains add-on (while on DRG).

The idea to put something up in big text so it's front and centre, along with colour-coded text came up, so I gave it a go based on what I've done for my GearSwap luas on different jobs. This was the result.

### Degei & Aita

Shows the current direct elemental weakness and the associated skillchain that should be used.  Optionally, you can choose to display the name of the ability used.

_< Example image with standard settings >_

_< Example image with ability name >_

_< Example image without colourful text >_


### Leshonn & Gartell

When using an ability which causes hands to switch from Thunder to Wind or vice versa, the dialogue box appears on screen.

_< Example image with standard settings >_

_< Example image without colourful text >_

## Settings.xml

| Setting       | Type     | Default | Description                                                                                                                                 |
| -------------|------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `auto_centre`  | `Boolean`     | `true`  | Automatically finds the middle of your game window to display the text box. If true, ignores the value set for `x_pos`.                      |
| `duration`     | `Integer`     | `10`    | The duration that the dialogue box stays on screen in seconds after the last ability.                                 |
| `show_ability_name` | `Boolean` | `false` | For Degei & Aita, toggles whether or not the name of the ability used is also shown on screen.                                               |
| background: `padding`  | `Integer`         | `25`    | The space around the text box that has a background. The value applies to top, botton, left, and right.                                      |
| background: `opacity`  | `Integer`      | `75`    | The background opacity of the text box. A value of 75 seems to be the same as the default value for EquipViewer. Higher is less transparent |
| font: `size` | `Integer` | `50` | The font size. |
| font: `use_colours` | `Boolean` | `true` | When `true`, the elemental nukes are coloured with the corresponding colour. Stone: yellow, Water: blue, etc. When `false`, all text is white. |
| pos: `x`        | `Integer`     | `700`   | The x-position of the top left corner of the text box from the left-hand-side of the window. Ignored if `auto_centre` is set to `true`.      |
| pos: `y`       | `Integer`      | `100`   | The y-position of the top left corner of the text box from the top of the window.                                                            |



## Commands

- `AitaAxed`
- `aa` - alias, because typing in 'AitaAxed' is tricky at the best of times

| Option      | Alias |          Description                                                                                                              |
| -------------|------- | ------------------------------------------------------------------------------------------------------------------------ |
| `reload` | `r` | Reloads the add-on as if you typed `lua r AitaAxed`.<br />Example: `aa r` |
| `clear`  | n/a | Force clear the screen if the text panel gets stuck on the screen.<br />Example: `aa clear` |
| `auto_centre` (soon) | `ac` | Allows setting the value for `auto_centre`.<br />Example: `aa auto_centre false` |
| `duration` (soon) | `d` | Sets the duration value.<br />Example: `aa duration 5` |
| `show_name` | `sn` | Sets the value for `show_ability_name`<br />Example: `aa sn true` |
| `padding` | n/a | Sets the value for the padding around the text in the dialogue box.<br />Example: `aa padding 30` |
| `opacity` | n/a | Sets the value for the background opacity of the dialogue box. Higher is less transparent.<br />Example: `aa opacity 80` |
| `size` | n/a | Sets the font size.<br />Example: `aa s 42` |
| `colourful` | `c` | Sets the value for `use_colours`.<br>`aa colourful false` |
| `pos x` (soon) | n/a | Sets the x-position value.<br/>Example: `aa pos x 800` |
| `pos y` (soon) | n/a | Sets the y-position value.<br/>Example: `aa pos y 50` |


## Known Issues

When there is a tonne of lag, sometimes it doesn't pick up the TP move. Currently I have no idea how to resolve this or if it is able to be resolved.

## Links

Resources used in the making of this add-on.

### Sammeh

&nbsp;&nbsp;&nbsp;&nbsp;Sammeh's React add-on was used as a starting point.<br />
&nbsp;&nbsp;&nbsp;&nbsp;GitHub: https://github.com/SammehFFXI

### Kaiconure (ux/core)

&nbsp;&nbsp;&nbsp;&nbsp;Kaiconure developed the ux/core script.<br />
&nbsp;&nbsp;&nbsp;&nbsp;GitHub: https://github.com/Kaiconure/

### Windower Development

&nbsp;&nbsp;&nbsp;&nbsp;GitHub: https://github.com/Windower/Lua/wiki

## Copyright

Copyright is stated in each lua script based on the guidelines set out in the Windower Documentation

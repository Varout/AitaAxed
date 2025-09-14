I really have to get around to doing this

# AitaAxed

**Contents**

- [About](#about)
- [Commands](#commands)
- [Settings.xml](#settingsxml)
- [Known Issues](#known-issues)
- [Links](#links)
- [Media](#media)

## About

Check out [releases](https://github.com/Varout/AitaAxed/releases) for the latest version.

AitaAxed came about as a more visual solution that doesn't rely on the chat log and React, when fighting specific bosses in Sortie. Someone suggested using React to print out to the log, however I'm either always looking at my party's HP numbers (while on WHM) or at my skillchains add-on (while on DRG).

The idea to put something up in big text so it's front and centre, along with colour-coded text came up, so I gave it a go based on what I've done for my GearSwap luas on different jobs. This was the result.

## Commands

- `AitaAxed`
- `aa` - alias, because typing in 'AitaAxed' is tricky at the best of times

| Option | Description                                         |
| ------ | --------------------------------------------------- |
| `r`    | Reloads the add-on as if you typed `lua r AitaAxed` |

## Settings.xml

| Setting             | Default | Description                                                                                                                                 |
| ------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `auto_centre`       | `true`  | Automatically finds the middle of your game window to display the text box. If true, ignores the value set for `x_pos`                      |
| `x_pos`             | `700`   | The x-position of the top left corner of the text box from the left-hand-side of the window. Ignored if `auto_centre` is set to `true`      |
| `y_pos`             | `110`   | The y-position of the top left corner of the text box from the top of the window                                                            |
| `font_size`         | `50`    | The size of the font                                                                                                                        |
| `padding`           | `25`    | The space around the text box that has a background. The value applies to top, botton, left, and right                                      |
| `bg_opacity`        | `75`    | The background opacity of the text box. A value of 75 seems to be the same as the default value for EquipViewer. Higher is less transparent |
| `show_ability_name` | `false` | For Degei & Aita, toggles whether or not the name of the ability used is also shown on screen                                               |
| `duration`          | `7`     | The duration that the text box stays on screen in seconds                                                                                   |

## Known Issues

When there is a tonne of lag, sometimes it doesn't pick up the TP move. Currently I have no idea how to resolve this or if it is able to be resolved.

## Links

Resources used in the making of this add-on.

### Sammeh

&nbsp;&nbsp;&nbsp;&nbsp;Sammeh's React add-on was used as a starting point.
&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/SammehFFXI

### Kaiconure (ux/core)

&nbsp;&nbsp;&nbsp;&nbsp;Kaiconure developed the ux/core script.
&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/Kaiconure/

### Windower Development

&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/Windower/Lua/wiki

## Media

Should probably put some examples here

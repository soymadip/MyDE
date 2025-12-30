<center>
  <h1>Rofi Colors</h1>
  <p>Custom color schemes for Rofi</p>
</center>

## Common Theme Variables

All themes provide these standardized variables for consistent usage across different Rofi configurations:

### Core Colors

| Variable          | Description                            |
| ----------------- | -------------------------------------- |
| `@transparent`    | Transparent color (`#00000000`)        |
| `@background`     | Primary background color               |
| `@background-alt` | Alternative/secondary background color |
| `@foreground`     | Primary text color (highest contrast)  |
| `@foreground-alt` | Secondary text color (lower contrast)  |

### Semantic Colors

| Variable      | Description                   |
| ------------- | ----------------------------- |
| `@active`     | Active/selected item color    |
| `@active-alt` | Alternative active item color |
| `@urgent`     | Urgent/error item color       |
| `@success`    | Success/positive item color   |
| `@disabled`   | Disabled/inactive item color  |
| `@separator`  | Separator line color          |

### Basic Color Aliases

| Variable  | Description                |
| --------- | -------------------------- |
| `@red`    | Red color variant          |
| `@green`  | Green color variant        |
| `@blue`   | Blue color variant         |
| `@yellow` | Yellow color variant       |
| `@orange` | Orange color variant       |
| `@purple` | Purple color variant       |
| `@cyan`   | Cyan color variant         |
| `@white`  | White/light color variant  |
| `@black`  | Black/dark color variant   |
| `@gray`   | Gray/neutral color variant |

## Usage

To use a theme in your Rofi configuration:

```rasi
@import "~/.config/rofi/colors/theme-name.rasi"

window {
    background-color: @background;
    text-color: @foreground;
}

element selected {
    background-color: @active;
    text-color: @background;
}
```

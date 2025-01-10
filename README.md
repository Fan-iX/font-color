A recipe to create [colored fonts](https://fonts.google.com/knowledge/introducing_type/introducing_color_fonts) from an existing font

## Requirements

- [nanoemoji](https://github.com/googlefonts/nanoemoji)
- inkscape (command line)
- perl
- gnu make

## Usage

First, prepare a two-column tsv with characters and corresponding colors, for example, `rainbow.map`:

```
A	#F8766D
B	#EE8043
C	#E18A00
D	#D19300
...
```

then run

```
make MAP=rainbow.map
```

output will be located in `build/Font.tff`. You can see the actual effect in `preview.html`.

#### `make` options

```
MAP            color mapping file
CHARS          characters to use [ default: all characters in the first column of $(MAP) ]
# appearance
TEMPLATE_FONT  font to use, in css `font-family` syntax
HEIGHT         character height, usually 1000 ~ 1500 [ default: 1024 ]
WIDTH          character width [ default: 768 ]
FONT_SIZE      character size [ default: 1024 ]
ASCENDER       baseline position, usually 3/5 ~ 4/5 of HEIGHT [ default: 768 ]
# metadata
FONT_NAME      famaily name of the font [ default: base name of $(MAP) ]
# output
BUILD_DIR      working directory [ default: bulid/ ]
```

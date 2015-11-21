# Ludoc

* TODO: Box and image/svg element types
* TODO: Layout logic

## Installation

Clone this repo! (`gem install` coming soon, maybe)

## Usage

```
Usage:  ludoc [options]
  -l=layout     yaml layout file (required)
  -i=input      csv input file (required)
  -o=output     output path for pdf file (default output is to stdout)
```

e.g., in a clone of this repo:

```
./bin/ludoc -l=lib/layouts/playing_card.yml -i=test.csv -o=output.pdf
```

## Layouts

A layout is a YAML file specifying the format of an individual game piece and the overall format of the end result PDF.

### Document options
* `units`: either `inches` or `points` (1 inch = 72 points)
* `width`: width of an individual game piece (in inches or points)
* `height`: height of an individual game piece (in inches or points)
* `orientation`: either `portrait` or `landscape`
* `rows`: number of rows of game pieces on a single page
* `columns`: number of columns of game pieces on a single page
* `count_column` (optional): the name of the input column which contains the number for how many times a game piece should be repeated
* `elements`: an array of elements to be rendered

### Element options
* `type`: `text`
* `align`: specify `left`, `right`, or `center` text-alignment
* `column`: the name of the input column which contains the text for this element
* `box`: text box measurements in the following format `left top width height` with the preferred units, e.g. `1" 0.5" 1.5" 2.5"` would define a 1.5" wide by 2.5" tall text box 1" from the left and 0.5" from the top of the game piece

## Input

An input file is a CSV that is combined with a layout to create game pieces. Input files define the actual pieces in your game.

The first row of an input file specifies the column names, the remaining row contains game piece data.

### Example

Here's an input file describing chess pieces:

```
Name,Color,Point Value,Count
Pawn,white,1,8
Knight,white,3,2
Bishop,white,3,2
Rook,white,5,2
Queen,white,9,1
King,white,0,1
Pawn,black,1,8
Knight,black,3,2
Bishop,black,3,2
Rook,black,5,2
Queen,black,9,1
King,black,0,1
```

## Contributing

1. Fork it ( https://github.com/modality/ludoc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

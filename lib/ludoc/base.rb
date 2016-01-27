require 'yaml'
require 'csv'
require 'prawn'

USAGE = <<-MSG
Usage:  ludoc [options]
  -l=layout     yaml layout file (required)
  -i=input      csv input file (required)
  -o=output     output pdf file (default output is to stdout)
MSG

module Ludoc
  class Base
    attr_accessor :layout, :input, :output_file, :pdf

    def initialize(args)
      bail if args.size == 0

      layout_file = args["l"]
      input_file = args["i"]
      output_file = args["o"]

      bail "ERROR: Specify a layout file with -l" unless layout_file
      bail "ERROR: No layout file named `#{layout_file}` exists" unless File.exist? layout_file
      bail "ERROR: Specify an input file with -i" unless input_file
      bail "ERROR: No input file named `#{input_file}` exists" unless File.exist? input_file

      begin
        @layout = Ludoc::Layout.new(YAML.load(File.read(File.expand_path(layout_file))))
      rescue
        bail "ERROR: Layout `#{layout_file}` is not a valid yaml file"
      end

      begin
        @input = CSV.read(File.expand_path(input_file))
      rescue
        bail "ERROR: Input `#{input_file}` is not a valid csv file"
      end

      @output_file = output_file
    end

    def bail(error = nil)
      puts USAGE
      puts "\n"+error if error
      exit 1
    end

    def text_element(text, el)
      pdf.text_box text,
                   at: [el.x, pdf.bounds.height - el.y],
                   align: el.align,
                   width: el.width,
                   height: el.height
    end

    def box_element(el)
      has_fill = false
      has_stroke = false

      if !el.fill_color.nil?
        has_fill = true
        pdf.fill_color el.fill_color
      end

      if !el.stroke_weight.nil?
        has_stroke = true
        pdf.line_width = el.stroke_weight
        pdf.stroke_color = el.stroke_color
      end

      if !el.stroke_color.nil?
        pdf.stroke_color = el.stroke_color
      end
    end

    def render_piece(row, col, game_piece)
      pos = [0 + col*layout.width, pdf.margin_box.height - row*layout.height]
      pdf.bounding_box(pos, {width: layout.width, height: layout.height}) do
        pdf.stroke_color 'CCCCCC'
        pdf.stroke_bounds
        pdf.float do
          layout.elements.each do |el|
            case el.type
            when 'text'
              text_element(game_piece.column_value(el.column), el)
            when 'box'
              box_element(el)
            end
          end
        end
      end
    end

    def render
      @pdf = Prawn::Document.new(page_layout: layout.orientation)

      column_names = input.shift.map(&:downcase)
      row = 0
      col = 0

      while input.size > 0 do
        game_piece = GamePiece.new(column_names, input.shift, layout.count_column)
        game_piece.count.times do |index|
          render_piece(row, col, game_piece)
          col += 1
          if col >= layout.columns
            col = 0
            row += 1
          end
          if row >= layout.rows && (index < game_piece.count - 1 || input.size > 0)
            row = 0
            pdf.start_new_page
          end
        end
      end

      if output_file
        pdf.render_file output_file
      else
        ios = IO.new STDOUT.fileno
        ios.write pdf.render
        ios.close
      end
    end
  end
end







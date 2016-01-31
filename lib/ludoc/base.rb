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
        @input_dir = File.dirname(File.expand_path(input_file))
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
      has_fill, has_stroke = set_fill_stroke(el)

      mode = :fill
      if has_fill && has_stroke
        mode = :fill_stroke
      elsif has_stroke
        mode = :stroke
      end

      pdf.text_box text,
                   at: [el.x, pdf.bounds.height - el.y],
                   align: el.align,
                   width: el.width,
                   height: el.height,
                   mode: mode
    end

    def box_element(el)
      has_fill, has_stroke = set_fill_stroke(el)

      if has_fill && has_stroke
        pdf.fill_and_stroke_rectangle [el.x, pdf.bounds.height - el.y], el.width, el.height
      elsif has_fill
        pdf.fill_rectangle [el.x, pdf.bounds.height - el.y], el.width, el.height
      elsif has_stroke
        pdf.stroke_rectangle [el.x, pdf.bounds.height - el.y], el.width, el.height
      end
    end

    def image_element(image, el)
      pdf.image File.join(@input_dir, image),
                at: [el.x, pdf.bounds.height - el.y],
                width: el.width ? el.width : nil,
                height: el.height ? el.height : nil
    end

    def set_fill_stroke(el)
      has_fill = false
      has_stroke = false

      if !el.fill_color.nil?
        has_fill = true
        pdf.fill_color el.fill_color
      end

      if !(el.stroke_weight.nil? || el.stroke_color.nil?)
        has_stroke = true
        pdf.line_width el.stroke_weight
        pdf.stroke_color el.stroke_color
      end

      return [has_fill, has_stroke]
    end

    def render_piece(row, col, game_piece)
      pos = [0 + col*layout.width, pdf.margin_box.height - row*layout.height]
      pdf.bounding_box(pos, {width: layout.width, height: layout.height}) do
        pdf.stroke_color 'CCCCCC'
        pdf.line_width 1
        pdf.stroke_bounds
        pdf.float do
          layout.elements.each do |el|
            pdf.save_graphics_state
            case el.type
            when 'text'
              text_element(game_piece.column_value(el.column), el)
            when 'box'
              box_element(el)
            when 'image'
              image_element(game_piece.column_value(el.column), el)
            end
            pdf.restore_graphics_state
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







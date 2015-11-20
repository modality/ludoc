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
    attr_accessor :layout, :input, :output_file

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

    def text_element(pdf, text, el)
      pdf.text_box text,
                   at: [el.x, pdf.bounds.height - el.y],
                   align: el.align,
                   width: el.width,
                   height: el.height
    end

    def render
      pdf = Prawn::Document.new(page_layout: layout.orientation)

      data_remaining = true
      opts = {width: layout.width, height: layout.height}

      column_names = input.shift.map(&:downcase)

      layout.rows.times do |j|
        layout.columns.times do |i|
          pos = [0 + i*layout.width, pdf.margin_box.height - j*layout.height]
          game_piece = input.shift
          if game_piece
            pdf.bounding_box(pos, opts) do
              pdf.stroke_color 'CCCCCC'
              pdf.stroke_bounds
              pdf.float do
                layout.elements.each do |el|
                  text_element(pdf, game_piece[column_names.index(el.column)], el)
                end
              end
            end
          else
            data_remaining = false
          end
          break unless data_remaining
        end
        break unless data_remaining
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







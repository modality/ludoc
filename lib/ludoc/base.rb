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
        @layout = YAML.load(File.read(File.expand_path(layout_file)))
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
      box = to_box(el["box"])
      pdf.text_box text,
                   at: [box[:x], pdf.bounds.height - box[:y]],
                   align: el["align"].downcase.to_sym,
                   width: box[:width],
                   height: box[:height]
    end

    def to_pts(str)
      str = str.chomp('"').to_f if str.is_a? String
      str * 72
    end

    def to_box(str)
      box = str.split(' ').map(&method(:to_pts))
      {x: box[0], y: box[1], width: box[2], height: box[3]}
    end

    def render
      pdf = Prawn::Document.new(page_layout: layout["orientation"].to_sym)

      data_remaining = true
      opts = {width: to_pts(layout["width"]), height: to_pts(layout["height"])}

      column_names = input.shift.map(&:downcase)

      layout["rows"].times do |j|
        layout["columns"].times do |i|
          pos = [0 + i*opts[:width], pdf.margin_box.height - j*opts[:height]]
          game_piece = input.shift
          if game_piece
            pdf.bounding_box(pos, opts) do
              pdf.stroke_color 'CCCCCC'
              pdf.stroke_bounds
              pdf.float do
                layout["elements"].each do |el|
                  case el["type"].downcase
                  when "text" then
                    text_element(pdf, game_piece[column_names.index(el["column"].downcase)], el)
                  end
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







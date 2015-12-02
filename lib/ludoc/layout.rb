module Ludoc
  class Layout
    attr_accessor :layout

    def initialize(layout)
      @layout = layout
    end

    def units
      @units ||= (layout["units"] && layout["units"].downcase.to_sym) || :points
    end

    def orientation
      @orientation ||= layout["orientation"].downcase.to_sym
    end

    def count_column
      @count_column ||= layout["count_column"].downcase
    end

    def width
      @width ||= coerce_to_pts(layout["width"])
    end

    def height
      @height ||= coerce_to_pts(layout["height"])
    end

    def rows
      @rows ||= layout["rows"]
    end

    def columns
      @columns ||= layout["columns"]
    end

    def elements
      @elements ||= layout["elements"].map {|el| Element.new(el, units)}
    end

    private

    def coerce_to_pts(val)
      units == :points ? val.to_f : Ludoc.to_pts(val)
    end
  end
end

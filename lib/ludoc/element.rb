module Ludoc
  class Element
    attr_accessor :element, :layout

    def initialize(element, layout)
      @element = element
      @layout = layout
    end

    def type
      element["type"].downcase
    end

    def column
      element["column"].downcase
    end

    def align
      element["align"].downcase.to_sym
    end

    def box
      return @box if @box
      tmp = element["box"].split(' ')
      tmp = tmp.map {|n| Ludoc.to_pts(n)} if layout.units == :inches
      @box = {x: tmp[0], y: tmp[1], width: tmp[2], height: tmp[3]}
    end

    def x
      box[:x]
    end
    
    def y
      box[:y]
    end

    def width
      box[:width]
    end

    def height
      box[:height]
    end
  end
end

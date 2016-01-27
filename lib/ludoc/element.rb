module Ludoc
  class Element
    def initialize(element, units)
      @element = element
      @units = units
    end

    def type
      @element["type"].downcase
    end

    def column
      @element["column"].downcase
    end

    def align
      @element["align"].downcase.to_sym
    end

    def box
      return @box if @box
      tmp = @element["box"].split(' ')
      tmp = tmp.map {|n| Ludoc.to_pts(n)} if @units == :inches
      @box = {x: tmp[0].to_f, y: tmp[1].to_f, width: tmp[2].to_f, height: tmp[3].to_f}
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

    def stroke_weight
      @units == :inches ? Ludoc.to_pts(@element["stroke_weight"].downcase.to_sym) : @element["stroke_weight"]
    end

    def stroke_color
      @element["stroke_color"].downcase.to_sym
    end

    def fill_color
      @element["fill_color"].downcase.to_sym
    end
  end
end

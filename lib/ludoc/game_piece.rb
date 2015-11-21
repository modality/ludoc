module Ludoc
  class GamePiece
    attr_accessor :layout, :columns, :row

    def initialize(layout, columns, row)
      @layout = layout
      @columns = columns
      @row = row
    end

    def count
      if layout.count_column
        column_value(layout.count_column).to_i
      else
        1
      end
    end

    def column_value(column)
      row[columns.index(column)]
    end
  end
end

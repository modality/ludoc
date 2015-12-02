module Ludoc
  class GamePiece
    def initialize(columns, row, count_column = nil)
      @columns = columns
      @row = row
      @count_column = count_column
    end

    def count
      if !@count_column.nil?
        column_value(@count_column).to_i
      else
        1
      end
    end

    def column_value(column)
      @row[@columns.index(column)]
    end
  end
end

require 'ludoc'
require 'minitest/autorun'

class TestGamePiece < Minitest::Unit::TestCase
  def setup
    columns = ['Name','Description','Count']
    row = ['Michael Hansen','Game Designer','29']
    @game_piece_1 = Ludoc::GamePiece.new(columns, row, 'Count')
    @game_piece_2 = Ludoc::GamePiece.new(columns, row)
  end

  def test_count
    assert_equal 29, @game_piece_1.count
    assert_equal 1, @game_piece_2.count
  end

  def test_column_value
    assert_equal 'Michael Hansen', @game_piece_1.column_value('Name')
    assert_equal 'Game Designer', @game_piece_1.column_value('Description')
  end
end

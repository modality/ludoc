require 'ludoc'
require 'minitest/autorun'

class TestElement < Minitest::Unit::TestCase
  def setup
    @element_points = Ludoc::Element.new({
      'align' => 'Left',
      'box'   => '20 10 200 100'
    }, :points)

    @element_inches = Ludoc::Element.new({
      'align' => 'right',
      'box'   => '10" 5 1.5" 2'
    }, :inches)
  end

  def test_align
    assert_equal :left, @element_points.align
    assert_equal :right, @element_inches.align
  end

  def test_points_parsing
    assert_equal 20, @element_points.x
    assert_equal 10, @element_points.y
    assert_equal 200, @element_points.width
    assert_equal 100, @element_points.height
  end

  def test_inches_parsing
    assert_equal 720, @element_inches.x
    assert_equal 360, @element_inches.y
    assert_equal 108, @element_inches.width
    assert_equal 144, @element_inches.height
  end
end

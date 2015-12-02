require 'ludoc'
require 'minitest/autorun'

class TestLayout < Minitest::Unit::TestCase
  def setup
    @layout_points = Ludoc::Layout.new({
      'orientation'   => 'portrait',
      'width'         => '640',
      'height'        => '480',
      'count_column'  => 'Count'
    })

    @layout_inches = Ludoc::Layout.new({
      'orientation'   => 'landscape',
      'units'         => 'inches',
      'width'         => '10"',
      'height'        => '5'
    })
  end

  def test_orientation
    assert_equal :portrait, @layout_points.orientation
    assert_equal :landscape, @layout_inches.orientation
  end

  def test_count_column
    assert_equal 'count', @layout_points.count_column
  end

  def test_points
    assert_equal 640, @layout_points.width
    assert_equal 480, @layout_points.height
  end

  def test_inches_conversion
    assert_equal 720, @layout_inches.width
    assert_equal 360, @layout_inches.height
  end
end

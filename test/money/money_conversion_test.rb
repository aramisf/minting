require 'bigdecimal'
require 'bigdecimal/util'

class MoneyConversionTest < Minitest::Test
  USD = Mint::Currency[:USD]

  def test_numeric_conversion
    nine_nine_nine = Mint::Money.new(999 / 100r, USD)

    assert_equal 9,          nine_nine_nine.to_i
    assert_equal 9.99,       nine_nine_nine.to_f
    assert_equal 999 / 100r, nine_nine_nine.to_r
  end

  def test_bigdecimal_conversion
    assert_equal '9.99'.to_d,           Mint::Money.new(9_99 / 100r, USD).to_d
    assert_equal '123_456_789.01'.to_d, Mint::Money.new(123_456_789_01 / 100r, USD).to_d
  end
end

class MoneyFormatTest < Minitest::Test
  USD   = Mint::Currency[:USD]
  BRL   = Mint::Currency[:BRL]
  FUEL  = Mint::Currency.register(:BRF, subunit: 3, symbol: 'R$ ')

  def test_numeric_simple_format
    money = Mint::Money.new(999 / 100r, USD)
    gas = Mint::Money.new(3457 / 1000r, FUEL)

    assert_equal '$9.99',    money.to_s
    assert_equal '9',        money.to_s(format: '%<amount>d')
    assert_equal '$9.99',    money.to_s(format: '%<symbol>s%<amount>f')
    assert_equal '$+9.99',   money.to_s(format: '%<symbol>s%<amount>+f')
    assert_equal '-9.99',    (-money).to_s(format: '%<amount>f')
    assert_equal '9.99',     money.to_s(format: '%<amount>f')
    assert_equal 'R$ 3.457', gas.to_s
  end

  def test_numeric_padding_format
    usd = Mint::Money.new(999 / 100r, USD)
    brl = Mint::Money.new(1234 / 100r, BRL)

    assert_equal 'xx      9',        usd.to_s(format: 'xx%<amount>7d')
    assert_equal '        9.99 USD', usd.to_s(format: '  %<amount>10f %<currency>s')
    assert_equal 'R$    +12.34',     brl.to_s(format: '%<symbol>2s%<amount>+10f')
    assert_equal '       -9.99',     (-usd).to_s(format: '  %<amount>10f')
  end

  def test_numeric_json_format
    brl = Mint.new(:BRL).money(10)
    jpy = Mint.new(:JPY).money(15)
    gas = Mint::Money.new(3457 / 1000r, FUEL)

    assert_equal '{"currency":"BRL","amount":"10.00"}', brl.to_json
    assert_equal '{"amount":"10.00"}', brl.to_json(:amount)

    assert_equal '{"currency":"JPY","amount":"15"}', jpy.to_json
    assert_equal '{"amount":"15"}', jpy.to_json(:amount)

    assert_equal '{"currency":"BRF","amount":"3.457"}', gas.to_json
    assert_equal '{"amount":"3.457"}', gas.to_json(:amount)
  end
end

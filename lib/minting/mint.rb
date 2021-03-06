
class Mint
  def self.currency(code)
    Currency[code]
  end

  def self.money(amount, currency)
    Money.new(amount.to_r, Currency[currency])
  end

  attr_reader :currency
  attr_reader :currency_code

  def initialize(currency)
    @currency = Currency[currency]
    raise KeyError, 'No currency found' unless @currency
    @currency_code = @currency.code
  end

  def money(amount)
    amount.zero? ? zero : Money.new(amount.to_r, currency)
  end

  def zero
    @zero ||= Money.new(0r, currency)
  end

  def inspect
    "<Mint:#{currency_code}>"
  end
end

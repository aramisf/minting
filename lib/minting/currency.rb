class Mint
  class Currency
    def self.[](currency)
      return currency if currency.is_a? Currency
      currencies[currency.to_s] || currencies[nil]
    end

    def self.currencies
      @currencies ||= {
        'AUD' => Currency.new('AUD', subunit: 2, symbol: '$'),
        'BRL' => Currency.new('BRL', subunit: 2, symbol: 'R$'),
        'CAD' => Currency.new('CAD', subunit: 2, symbol: 'R$'),
        'CHF' => Currency.new('CHF', subunit: 2, symbol: 'Fr'),
        'CNY' => Currency.new('CNY', subunit: 2, symbol: '¥'),
        'EUR' => Currency.new('EUR', subunit: 2, symbol: '€'),
        'GBP' => Currency.new('GBP', subunit: 2, symbol: '£'),
        'JPY' => Currency.new('JPY', subunit: 0, symbol: '¥'),
        'MXN' => Currency.new('MXN', subunit: 2, symbol: '$'),
        'NZD' => Currency.new('NZD', subunit: 2, symbol: '$'),
        'PEN' => Currency.new('PEN', subunit: 2, symbol: 'S/.'),
        'SEK' => Currency.new('SEK', subunit: 2, symbol: 'kr'),
        'USD' => Currency.new('USD', subunit: 2, symbol: '$')
      }
    end

    def self.register(code, subunit:, symbol: '')
      code = code.to_s
      currencies[code] || register!(code, subunit: subunit, symbol: symbol)
    end

    def self.register!(code, subunit:, symbol: '')
      code = code.to_s
      raise ArgumentError, "Currency code must be a 3 letter String or Symbol ('USD', :EUR)" unless code =~ /^[A-Z]{3}$/
      raise KeyError,      "Currency: #{code} already registered"                            if currencies[code]
      currencies[code] = Currency.new(code, subunit: subunit.to_i, symbol: symbol.to_s).freeze
    end

    attr_reader :code
    attr_reader :subunit
    attr_reader :symbol

    def format(amount, format: '')
      amount = amount.amount if amount.is_a?(Mint::Money)

      format = format.empty? ? '%<symbol>s%<amount>f' : format.dup
      format.gsub!(/%<amount>(\+?\d*)f/, "%<amount>\\1.#{subunit}f")

      verbosity = $VERBOSE
      $VERBOSE = false
      formatted = Kernel.format(format, amount: amount, currency: code, symbol: symbol)
      $VERBOSE = verbosity
      formatted
    end

    def inspect
      "<Currency:(#{code} #{symbol} #{subunit})>"
    end

    private

    def initialize(code, subunit:, symbol:)
      @code = code
      @subunit = subunit
      @symbol = symbol
    end
  end
end

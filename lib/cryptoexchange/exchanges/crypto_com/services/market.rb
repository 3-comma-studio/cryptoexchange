module Cryptoexchange::Exchanges
  module CryptoCom
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super ticker_url
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::CryptoCom::Market::API_URL}/public/get-ticker"
        end

        def adapt_all(output)
          output['result']['data'].map do |output|
            base, target = output["i"].split('_')
            market_pair = Cryptoexchange::Models::MarketPair.new(
                            base: base,
                            target: target,
                            market: CryptoCom::Market::NAME
                          )

            adapt(output, market_pair)
          end
        end

        def adapt(output, market_pair)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = CryptoCom::Market::NAME
          ticker.bid       = NumericHelper.to_d(output['b'])
          ticker.ask       = NumericHelper.to_d(output['k'])
          ticker.last      = NumericHelper.to_d(output['a'])
          ticker.volume    = NumericHelper.to_d(output['v'])
          ticker.high      = NumericHelper.to_d(output['h'])
          ticker.low       = NumericHelper.to_d(output['l'])
          ticker.change    = NumericHelper.to_d(output['c'])
          ticker.timestamp = nil
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end

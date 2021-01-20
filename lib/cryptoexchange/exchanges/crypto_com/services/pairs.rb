module Cryptoexchange::Exchanges
  module CryptoCom
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::CryptoCom::Market::API_URL}/public/get-instruments"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          output['result']['instruments'].map do |output|
            Cryptoexchange::Models::MarketPair.new(
              base: output['base_currency'],
              target: output['quote_currency'],
              market: CryptoCom::Market::NAME
            )
          end
        end
      end
    end
  end
end

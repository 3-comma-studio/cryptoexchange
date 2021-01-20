module Cryptoexchange::Exchanges
  module CryptoCom
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base   = market_pair.base
          target = market_pair.target
          "#{Cryptoexchange::Exchanges::CryptoCom::Market::API_URL}/public/get-trades?instrument_name=#{base}_#{target}"
        end

        def adapt(output, market_pair)
          output['result']['data'].collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade['d']
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.market    = CryptoCom::Market::NAME
            tr.type      = trade['s'].downcase
            tr.price     = trade['p']
            tr.amount    = trade['q']
            tr.timestamp = trade['t'].to_i
            tr.payload   = trade
            tr
          end
        end
      end
    end
  end
end

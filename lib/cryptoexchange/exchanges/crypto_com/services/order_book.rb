module Cryptoexchange::Exchanges
  module CryptoCom
    module Services
      class OrderBook < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base   = market_pair.base
          target = market_pair.target
          "#{Cryptoexchange::Exchanges::CryptoCom::Market::API_URL}/public/get-book?instrument_name=#{base}_#{target}"
        end

        def adapt(output, market_pair)
          order_book = Cryptoexchange::Models::OrderBook.new

          order_book.base      = market_pair.base
          order_book.target    = market_pair.target
          order_book.market    = CryptoCom::Market::NAME
          order_book.asks      = adapt_orders output['result']['data'].first['asks']
          order_book.bids      = adapt_orders output['result']['data'].first['bids']
          order_book.payload   = output
          order_book
        end

        def adapt_orders(orders)
          orders.collect do |order_entry|
            Cryptoexchange::Models::Order.new(price:  order_entry[0],
                                              amount: order_entry[1]
            )
          end
        end
      end
    end
  end
end

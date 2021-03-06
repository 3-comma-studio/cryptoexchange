module Cryptoexchange::Exchanges
  module Iqfinex
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
          "#{Cryptoexchange::Exchanges::Iqfinex::Market::API_URL}/v1/orderbook/#{base}#{target}/0"
        end

        def adapt(output, market_pair)
          order_book = Cryptoexchange::Models::OrderBook.new

          order_book.base      = market_pair.base
          order_book.target    = market_pair.target
          order_book.market    = Iqfinex::Market::NAME
          order_book.asks      = adapt_orders HashHelper.dig(output, 'data', 'sell')
          order_book.bids      = adapt_orders HashHelper.dig(output, 'data', 'buy')
          order_book.timestamp = nil
          order_book.payload   = output
          order_book
        end

        def adapt_orders(orders)
          orders.collect do |price, order_entry|
            amount, _rest = order_entry
            Cryptoexchange::Models::Order.new(price:     price,
                                              amount:    amount,
                                              timestamp: nil)
          end
        end
      end
    end
  end
end

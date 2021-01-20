module Cryptoexchange::Exchanges
  module CryptoCom
    class Market < Cryptoexchange::Models::Market
      NAME = 'crypto_com'
      API_URL = 'https://api.crypto.com/v2'

      def self.trade_page_url(args={})
        "https://crypto.com/exchange/trade/spot/#{args[:base]}_#{args[:target]}"
      end
    end
  end
end

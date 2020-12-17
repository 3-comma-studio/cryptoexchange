module Cryptoexchange::Exchanges
  module Uniswap
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        STABLECOINS_TARGETS = %w{ DAI USDC USDT }
        WETH_TARGET = ["WETH"]
        RECOGNIZED_TARGETS = STABLECOINS_TARGETS + WETH_TARGET

        def pairs_url
          "#{Cryptoexchange::Exchanges::Uniswap::Market::API_URL}/exchanges?platform=uniswap-v2&api-key=#{Cryptoexchange::Exchanges::Uniswap::Market.api_key}"
        end

        def fetch
          output = fetch_via_api(pairs_url)
          adapt(output)
        end

        def adapt(output)
          market_pairs = []

          output = output["results"].select { |ticker| RECOGNIZED_TARGETS.include? ticker["assets"][1]["symbol"] }
          output.each do |pair|
            base = pair["assets"][0]["symbol"]
            base_address = pair["assets"][0]["address"]
            
            target = pair["assets"][1]["symbol"]
            target_address = pair["assets"][1]["address"]
            
            # Fix WETH as ETH
            if pair["assets"][1]["symbol"] == "WETH"
              target = "ETH"  
              target_address = "ETH"
            end

            market_pairs << Cryptoexchange::Models::MarketPair.new(
                              base: base,
                              base_address: base_address,
                              target: target,
                              target_address: target_address,
                              market: Uniswap::Market::NAME
                            )
          end
          market_pairs
        end
      end
    end
  end
end

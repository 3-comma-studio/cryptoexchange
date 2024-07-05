require "graphql/client"
require "graphql/client/http"

module Cryptoexchange::Exchanges
  module Balancer
    class TheGraphClient < Cryptoexchange::Models::Market
      HTTP = GraphQL::Client::HTTP.new("https://gateway-arbitrum.network.thegraph.com/api/02384c524966b1f8b6591fcae4650f70/subgraphs/id/C4ayEZP2yTXRAB8vSaTrgN4m9anTe9Mdm2ViyiAuV9TV") do
      end
      Schema = GraphQL::Client.load_schema(HTTP)
      Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

      SwapsQuery = Client.parse <<-'GRAPHQL'
      query($from: String!, $to: String!, $range_timestamp: Int!)
      {
        swaps(orderBy: timestamp, orderDirection: desc, first: 1000, where: { tokenInSym: $from, tokenOutSym: $to, timestamp_gte: $range_timestamp }) {
          id,
          tokenInSym,
          tokenOutSym,
          tokenAmountIn,
          tokenAmountOut,
          timestamp
        }
      }
      GRAPHQL
    end
  end
end

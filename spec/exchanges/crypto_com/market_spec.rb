require 'spec_helper'

RSpec.describe Cryptoexchange::Exchanges::CryptoCom::Market do
  it { expect(described_class::NAME).to eq 'crypto_com' }
  it { expect(described_class::API_URL).to eq 'https://api.crypto.com/v2' }
end

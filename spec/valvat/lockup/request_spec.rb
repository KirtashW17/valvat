# frozen_string_literal: true

require 'spec_helper'

describe Valvat::Lookup::Request do
  it 'returns Response on success' do
    response = described_class.new('IE6388047V', {}).perform
    expect(response).to be_a(Valvat::Lookup::Response)
    if response.is_a?(Valvat::Lookup::Fault)
      puts "Skipping IE vies request spec; response = #{response.inspect}"
    else
      expect(response.to_hash[:name]).to eql('GOOGLE IRELAND LIMITED')
    end
  end

  it 'returns Fault on failure' do
    response = described_class.new('XC123123', {}).perform
    expect(response).to be_a(Valvat::Lookup::Fault)
    expect(response.to_hash).to eql({ valid: false })
  end
end

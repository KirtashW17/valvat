# frozen_string_literal: true

require 'spec_helper'

describe Valvat::Checksum::ES do
  %w[ESA13585625 ESB83871236 ESE54507058 ES25139013J ESQ1518001A ESQ5018001G ESX4942978W ESX7676464F ESB10317980
     ESY3860557K ESY2207765D].each do |valid_vat|
    it "returns true on valid VAT #{valid_vat}" do
      expect(Valvat::Checksum.validate(valid_vat)).to be(true)
    end

    invalid_vat = "#{valid_vat[0..-6]}#{valid_vat[-2]}#{valid_vat[-5]}#{valid_vat[-4]}#{valid_vat[-3]}#{valid_vat[-1]}"

    it "returns false on invalid VAT #{invalid_vat}" do
      expect(Valvat::Checksum.validate(invalid_vat)).to be(false)
    end
  end

  describe 'some CIF categories (PQRSW) require control-digit to be a letter' do
    invalid_vat = "ESP65474207"
    valid_vat = "ESP6547420G"

    it "returns false on invalid VAT #{invalid_vat}" do
      expect(Valvat::Checksum.validate(invalid_vat)).to be(false)
    end

    it "returns true on valid VAT #{valid_vat}" do
      expect(Valvat::Checksum.validate(valid_vat)).to be(true)
    end
  end

  describe 'some CIF categories (CDFGJNUV) allow both a numeric check digit and a letter' do
    %w[ESC65474207 ESC6547420G].each do |valid_vat|
      it "returns true on valid VAT #{valid_vat}" do
        expect(Valvat::Checksum.validate(valid_vat)).to be(true)
      end
    end
  end

  describe 'if first two numeric digits are 00 (not resident), check digit should be a letter' do
    invalid_vat = "ESC00474205"
    valid_vat = "ESC0047420E"
    it "returns false on invalid VAT #{invalid_vat}" do
      expect(Valvat::Checksum.validate(invalid_vat)).to be(false)
    end

    it "returns true on valid VAT #{valid_vat}" do
      expect(Valvat::Checksum.validate(valid_vat)).to be(true)
    end
  end

  describe "if starts with a NIE char (XYZ), is always a natural person" do
    invalid_vat = "ESX65474207"
    it "returns false on invalid VAT #{invalid_vat}" do
      expect(Valvat::Checksum.validate(invalid_vat)).to be(false)
    end
  end

end

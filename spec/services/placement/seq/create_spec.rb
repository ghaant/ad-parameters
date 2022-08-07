require 'rails_helper'

RSpec.describe Placement::Seq::Create do
  let!(:input_hash) do
    {
      'Creatives' => {
        'Creative' => [
          { 'id' => 'Video-1', 'price' => '6.4567', 'currency' => 'EUR' },
          { 'id' => 'Video-4', 'price' => '1.1234', 'currency' => 'USD' },
          { 'id' => 'Video-7', 'price' => '55.123', 'currency' => 'SEK' },
          { 'id' => 'Video-12', 'price' => '16.4567', 'currency' => 'EUR' },
          { 'id' => 'Video-25', 'price' => '9.4567', 'currency' => 'USD' }
        ]
      },
      'Placements' => {
        'Placement' => [
          { 'id' => 'plc-1', 'floor' => '1.3456', 'currency' => 'EUR' },
          { 'id' => 'plc-2', 'floor' => '90.234', 'currency' => 'SEK' },
          { 'id' => 'plc-3', 'floor' => '8.343', 'currency' => 'TYR' },
          { 'id' => 'plc-4', 'floor' => '20.56', 'currency' => 'USD' },
          { 'id' => 'plc-5', 'floor' => '27.9856', 'currency' => 'EUR' },
          { 'id' => 'plc-6', 'floor' => '22.5656', 'currency' => 'SEK' },
          { 'id' => 'plc-7', 'floor' => '0', 'currency' => 'EUR' },
          { 'id' => 'plc-8', 'floor' => '1.3456', 'currency' => 'USD' }
        ]
      }
    }
  end

  describe '#initialize' do
    it 'fetches an array of placements correctly' do
      expect(described_class.new(input_hash).instance_variable_get(:@raw_placements)).to match_array(
        [
          { 'id' => 'plc-1', 'floor' => '1.3456', 'currency' => 'EUR' },
          { 'id' => 'plc-2', 'floor' => '90.234', 'currency' => 'SEK' },
          { 'id' => 'plc-3', 'floor' => '8.343', 'currency' => 'TYR' },
          { 'id' => 'plc-4', 'floor' => '20.56', 'currency' => 'USD' },
          { 'id' => 'plc-5', 'floor' => '27.9856', 'currency' => 'EUR' },
          { 'id' => 'plc-6', 'floor' => '22.5656', 'currency' => 'SEK' },
          { 'id' => 'plc-7', 'floor' => '0', 'currency' => 'EUR' },
          { 'id' => 'plc-8', 'floor' => '1.3456', 'currency' => 'USD' }
        ]
      )
    end

    it 'fetches an array of creatives correctly' do
      expect(described_class.new(input_hash).instance_variable_get(:@raw_creatives)).to match_array(
        [
          { 'id' => 'Video-1', 'price' => '6.4567', 'currency' => 'EUR' },
          { 'id' => 'Video-4', 'price' => '1.1234', 'currency' => 'USD' },
          { 'id' => 'Video-7', 'price' => '55.123', 'currency' => 'SEK' },
          { 'id' => 'Video-12', 'price' => '16.4567', 'currency' => 'EUR' },
          { 'id' => 'Video-25', 'price' => '9.4567', 'currency' => 'USD' }
        ]
      )
    end
  end

  describe 'private methods' do
    describe '#groom_placements' do
      it 'grooms placements' do
        expect(described_class.new(input_hash).send(:groom_placements)).to match_array(
          [
            { 'id' => 'plc-1', 'floor' => 1.3456, 'currency' => 'EUR' },
            { 'id' => 'plc-3', 'floor' => 2.5205438066465256, 'currency' => 'EUR' },
            { 'id' => 'plc-4', 'floor' => 18.194690265486727, 'currency' => 'EUR' },
            { 'id' => 'plc-5', 'floor' => 27.9856, 'currency' => 'EUR' },
            { 'id' => 'plc-7', 'floor' => 0, 'currency' => 'EUR' },
            { 'id' => 'plc-8', 'floor' => 1.1907964601769911, 'currency' => 'EUR' }
          ]
        )
      end
    end

    describe '#groom_creatives' do
      it 'grooms creatives' do
        expect(described_class.new(input_hash).send(:groom_creatives)).to match_array(
          [
            { 'id' => 'Video-1', 'price' => 6.4567, 'currency' => 'EUR' },
            { 'id' => 'Video-4', 'price' => 0.9941592920353983, 'currency' => 'EUR' },
            { 'id' => 'Video-12', 'price' => 16.4567, 'currency' => 'EUR' },
            { 'id' => 'Video-25', 'price' => 8.368761061946904, 'currency' => 'EUR' }
          ]
        )
      end
    end
  end

  describe '#run' do
    it 'creates placement seq message' do
      expect { described_class.new(input_hash).run }.to output(
        '<FYBER::Userconfiguration::PlacementSeq: placement: [<FYBER::Userconfiguration::Placement: id: "plc-1", creative: [<FYBER::Userconfiguration::Creative: id: "Video-1", price: 6.456699848175049>, <FYBER::Userconfiguration::Creative: id: "Video-12", price: 16.45669937133789>, <FYBER::Userconfiguration::Creative: id: "Video-25", price: 8.36876106262207>]>, <FYBER::Userconfiguration::Placement: id: "plc-3", creative: [<FYBER::Userconfiguration::Creative: id: "Video-1", price: 6.456699848175049>, <FYBER::Userconfiguration::Creative: id: "Video-12", price: 16.45669937133789>, <FYBER::Userconfiguration::Creative: id: "Video-25", price: 8.36876106262207>]>, <FYBER::Userconfiguration::Placement: id: "plc-7", creative: [<FYBER::Userconfiguration::Creative: id: "Video-1", price: 6.456699848175049>, <FYBER::Userconfiguration::Creative: id: "Video-4", price: 0.9941592812538147>, <FYBER::Userconfiguration::Creative: id: "Video-12", price: 16.45669937133789>, <FYBER::Userconfiguration::Creative: id: "Video-25", price: 8.36876106262207>]>, <FYBER::Userconfiguration::Placement: id: "plc-8", creative: [<FYBER::Userconfiguration::Creative: id: "Video-1", price: 6.456699848175049>, <FYBER::Userconfiguration::Creative: id: "Video-12", price: 16.45669937133789>, <FYBER::Userconfiguration::Creative: id: "Video-25", price: 8.36876106262207>]>]>'
      ).to_stdout
    end
  end

end

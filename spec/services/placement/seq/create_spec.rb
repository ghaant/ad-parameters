require 'rails_helper'

RSpec.describe Placement::Seq::Create do
  let!(:input_hash) do
    {
      'Configuration' => {
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
    context 'when the XML hash contains necessary data' do
      it 'creates placement seq message' do
        expect(described_class.new(input_hash).run.to_h).to eq(
          {
            placement: [
              {
                id: 'plc-1',
                creative: [
                  { id: 'Video-1', price: 6.456699848175049 },
                  { id: 'Video-12', price: 16.45669937133789 },
                  { id: 'Video-25', price: 8.36876106262207 }
                ]
              },
              {
                id: 'plc-3',
                creative: [
                  { id: 'Video-1', price: 6.456699848175049 },
                  { id: 'Video-12', price: 16.45669937133789 },
                  { id: 'Video-25', price: 8.36876106262207 }
                ]
              },
              {
                id: 'plc-7',
                creative: [
                  { id: 'Video-1', price: 6.456699848175049 },
                  { id: 'Video-4', price: 0.9941592812538147 },
                  { id: 'Video-12', price: 16.45669937133789 },
                  { id: 'Video-25', price: 8.36876106262207 }
                ]
              },
              {
                id: 'plc-8',
                creative: [
                  { id: 'Video-1', price: 6.456699848175049 },
                  { id: 'Video-12', price: 16.45669937133789 },
                  { id: 'Video-25', price: 8.36876106262207 }
                ]
              }
            ]
          }
        )
      end
    end

    context 'when the XML hash is empty' do
      it 'an empty Protobuf message' do
        expect(described_class.new(nil).run.is_a?(FYBER::Userconfiguration::PlacementSeq)).to be(true)
        expect(described_class.new(nil).run).blank?
      end
    end

    context 'when the XML hash misses placements or creatives data' do
      let!(:input_hash) do
        {
          'Configuration' => {
            'Placements' => {
              'Placement' => [
                { 'id' => 'plc-1', 'floor' => '1.3456', 'currency' => 'EUR' },
              ]
            }
          }
        }
      end

      it 'an empty Protobuf message' do
        expect(described_class.new(input_hash).run.is_a?(FYBER::Userconfiguration::PlacementSeq)).to be(true)
        expect(described_class.new(input_hash).run).blank?
      end
    end

    context 'when there are no allowed creative currencies or placement ones' do
      let!(:input_hash) do
        {
          'Configuration' => {
            'Creatives' => {
              'Creative' => [
                { 'id' => 'Video-7', 'price' => '55.123', 'currency' => 'SEK' },
              ]
            },
            'Placements' => {
              'Placement' => [
                { 'id' => 'plc-1', 'floor' => '1.3456', 'currency' => 'EUR' },
              ]
            }
          }
        }
      end

      it 'an empty Protobuf message' do
        expect(described_class.new({}).run.is_a?(FYBER::Userconfiguration::PlacementSeq)).to be(true)
        expect(described_class.new({}).run).blank?
      end
    end
  end
end

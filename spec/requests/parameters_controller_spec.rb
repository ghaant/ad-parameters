require 'rails_helper'

RSpec.describe 'ParametersController', type: :request do
  describe 'parse_xml' do
    context 'when XML is empty' do
      it 'returns 422' do
        get '/parse_xml', headers: { 'CONTENT_TYPE' => 'application/xml' }
        expect(response).to have_http_status(422)
        expect(response.body).to eq('An input XML is empty.')
      end
    end

    context 'when XML format is incorrect' do
      it 'returns 422' do
        get '/parse_xml',
            env: { 'RAW_POST_DATA' => '<Creative id="Video-1" price="6.4567" currency"EUR"/>' },
            headers: { 'CONTENT_TYPE' => 'application/xml' }

        expect(response).to have_http_status(422)
        expect(response.body).to eq('An input XML format is incorrect.')
      end
    end

    context 'when XML is well-formatted' do
      let!(:input_xml) do
        '<Configuration>'\
          '<Creatives>'\
            '<Creative id="Video-1" price="6.4567" currency="EUR"/>'\
          '</Creatives>'\
          '<Placements>'\
            '<Placement id="plc-7" floor="0" currency="EUR"/>'\
          '</Placements>'\
        '</Configuration>'
      end
      it 'print a Protobuf message to stdout' do
        get '/parse_xml',
            env: { 'RAW_POST_DATA' => input_xml },
            headers: { 'CONTENT_TYPE' => 'application/xml' }

        expect(response).to have_http_status(200)
        expect(response.body).to eq('Processed.')

        expect do
          get '/parse_xml',
              env: { 'RAW_POST_DATA' => input_xml },
              headers: { 'CONTENT_TYPE' => 'application/xml' }
        end.to output(
          '<FYBER::Userconfiguration::PlacementSeq: '\
            'placement: ['\
              '<FYBER::Userconfiguration::Placement: '\
                'id: "plc-7", '\
                'creative: [<FYBER::Userconfiguration::Creative: id: "Video-1", price: 6.456699848175049>]>'\
            ']'\
          '>'
        ).to_stdout
      end
    end
  end
end

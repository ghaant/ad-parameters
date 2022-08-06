require './app/protobuf/FYBER/userconfiguration'

class Placement::Seq::Create
  RATES =
    {
      'TYR' => 3.31,
      'USD' => 1.13
    }.freeze

  def initialize(xml_hash)
    @eur_placements = []
    @eur_creatives = []
    @raw_placements = xml_hash['Placements']['Placement']
    @raw_creatives = xml_hash['Creatives']['Creative']
    @placement_seq_message = ::FYBER::Userconfiguration::PlacementSeq.new
  end

  def run
    format_placements
    format_creatives
    create_placement_seq_message

    $stdout.print(@placement_seq_message)
  end

  private

  def format_placements
    @raw_placements.each do |placement|
      next if placement['currency'] == 'SEK'

      eur_placement = placement
      eur_placement['floor'] = eur_placement['floor'].to_f.round(2)

      unless eur_placement['currency'] == 'EUR'
        eur_placement['floor'] = (eur_placement['floor'] / RATES[eur_placement['currency']]).round(2)
        eur_placement['currency'] = 'EUR'
      end

      @eur_placements << eur_placement
    end
  end

  def format_creatives
    @raw_creatives.each do |creative|
      next if creative['currency'] == 'SEK'

      eur_creative = creative
      eur_creative['price'] = eur_creative['price'].to_f.round(2)

      unless eur_creative['currency'] == 'EUR'
        eur_creative['price'] = (eur_creative['price'] / RATES[eur_creative['currency']]).round(2)
        eur_creative['currency'] = 'EUR'
      end

      @eur_creatives << eur_creative
    end
  end

  def create_placement_seq_message
    @eur_placements.each do |placement|
      placement_message = ::FYBER::Userconfiguration::Placement.new(id: placement['id'], creative: [])

      @eur_creatives.each do |creative|
        if creative['price'] >= placement['floor']
          placement_message['creative'] <<
            ::FYBER::Userconfiguration::Creative.new(id: creative['id'], price: creative['price'])
        end
      end

      @placement_seq_message['placement'] << placement_message unless placement_message['creative'].blank?
    end
  end
end

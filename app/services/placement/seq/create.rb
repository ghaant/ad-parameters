class Placement::Seq::Create
  CURRENCY_RATES =
    {
      'EUR' => 1.0,
      'TYR' => 3.31,
      'USD' => 1.13
    }.freeze

  def initialize(xml_hash)
    @eur_placements = []
    @eur_creatives = []
    @raw_placements = xml_hash&.dig('Configuration', 'Placements', 'Placement')
    @raw_creatives = xml_hash&.dig('Configuration', 'Creatives', 'Creative')
    # Hash.from_xml in ParameterController makes it an array, only when there are more than 1 placements/creatives.
    @raw_placements = [@raw_placements] if @raw_placements.is_a?(Hash)
    @raw_creatives = [@raw_creatives] if @raw_creatives.is_a?(Hash)
    @placement_seq_message = ::FYBER::Userconfiguration::PlacementSeq.new
  end

  def run
    return @placement_seq_message if @raw_placements.blank? || @raw_creatives.blank?

    groom_placements
    groom_creatives
    create_placement_seq_message
  end

  private

  def groom_placements
    @raw_placements.each do |placement|
      # Rates of other currencies are unknown.
      next unless CURRENCY_RATES.has_key?(placement['currency'])

      eur_placement = placement
      eur_placement['floor'] = eur_placement['floor'].to_f

      unless eur_placement['currency'] == 'EUR'
        eur_placement['floor'] = (eur_placement['floor'] / CURRENCY_RATES[eur_placement['currency']])
        eur_placement['currency'] = 'EUR'
      end

      @eur_placements << eur_placement
    end

    @eur_placements
  end

  def groom_creatives
    @raw_creatives.each do |creative|
      # Rates of other currencies are unknown.
      next unless CURRENCY_RATES.has_key?(creative['currency'])

      eur_creative = creative
      eur_creative['price'] = eur_creative['price'].to_f

      unless eur_creative['currency'] == 'EUR'
        eur_creative['price'] = (eur_creative['price'] / CURRENCY_RATES[eur_creative['currency']])
        eur_creative['currency'] = 'EUR'
      end

      @eur_creatives << eur_creative
    end

    @eur_creatives
  end

  def create_placement_seq_message
    @eur_placements&.each do |placement|
      placement_message = ::FYBER::Userconfiguration::Placement.new(id: placement['id'], creative: [])

      @eur_creatives&.each do |creative|
        if creative['price'] >= placement['floor']
          placement_message['creative'] <<
            ::FYBER::Userconfiguration::Creative.new(id: creative['id'], price: creative['price'])
        end
      end

      @placement_seq_message['placement'] << placement_message unless placement_message['creative'].blank?
    end

    @placement_seq_message
  end
end

# require './app/messages/FYBER/userconfiguration'

class Placement::Seq::Create
  RATES =
    {
      'TYR' => 3.31,
      'USD' => 1.13
    }

  EUR_TO_TYR = 3.31
  EUR_TO_USD = 1.13

  def self.run(xml_hash)
    eur_placements = []

    xml_hash['Placements']['Placement'].each do |placement|
      next if placement['currency'] == 'SEK'

      eur_placement = placement
      eur_placement['floor'] = eur_placement['floor'].to_f

      unless eur_placement['currency'] == 'EUR'
        eur_placement['floor'] = (eur_placement['floor'] / RATES[eur_placement['currency']]).round(2)
        eur_placement['currency'] = 'EUR'
      end

      eur_placements << eur_placement
    end

    puts eur_placements
  end
end

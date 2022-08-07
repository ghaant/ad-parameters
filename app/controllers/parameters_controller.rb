class ParametersController < ApplicationController
  def parse_xml
    print Placement::Seq::Create.new(Hash.from_xml(request.raw_post)['Configuration']).run
    render json: 'Processed', status: 200
  rescue REXML::ParseException
    render json: 'An input XML format is incorrect', status: 422
  end
end

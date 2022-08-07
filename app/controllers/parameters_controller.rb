class ParametersController < ApplicationController
  before_action :xml_to_hash, only: [:parse_xml]

  def parse_xml
    print Placement::Seq::Create.new(@xml_hash).run
    render json: 'Processed.', status: 200
  end

  private

  def xml_to_hash
    return render json: 'An input XML is empty.', status: 422 if request.raw_post.blank?

    @xml_hash = Hash.from_xml(request.raw_post)
  rescue REXML::ParseException
    render json: 'An input XML format is incorrect.', status: 422
  end
end

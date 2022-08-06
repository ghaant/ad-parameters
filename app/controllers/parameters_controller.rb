class ParametersController < ApplicationController
  def parse_xml
    #Hash.from_xml(File.read('public/dashboard_configuration/2022-08-04.xml'))
    Placement::Seq::Create.new(Hash.from_xml(request.raw_post)['Configuration']).run

    render status: 200
  end
end

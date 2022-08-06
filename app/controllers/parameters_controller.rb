class ParametersController < ApplicationController
  def parse_xml
    #Hash.from_xml(File.read('public/dashboard_configuration/2022-08-04.xml'))
    configuration_hash = Hash.from_xml(request.raw_post)['Configuration']
    Placement::Seq::Create.run(configuration_hash)

    render status: 200 
  end
end

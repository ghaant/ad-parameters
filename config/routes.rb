Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/parse_xml', to: 'parameters#parse_xml'
end

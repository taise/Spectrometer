require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

require './models/stv_wlm_service_class_state'

class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    'Hello Spectrometer'
  end

  get '/service_class_states' do
    p @service_class_states = StvWlmServiceClassState.all
    slim :service_class_state
  end
end

require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'

$LOAD_PATH << './models'
require 'redshift'
require 'stv_wlm_service_class_state'

class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    'Hello Spectrometer'
  end

  get '/service_class_states' do
     @service_class_states = StvWlmServiceClassState.all
    slim :service_class_state
  end
end

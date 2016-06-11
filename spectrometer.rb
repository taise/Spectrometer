require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'chartkick'

require './lib/redshift_metric'
require './lib/time'

$LOAD_PATH << './models'
require 'redshift'
require 'pg_user'
require 'stl_error'
require 'stv_wlm_service_class_state'

ENV['TZ'] = 'Asia/Tokyo'

class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    slim :index
  end

  get '/performances' do
    metrics = RedshiftMetric.new('CPUUtilization').get_statistics
    @performances = metrics.datapoints.sort_by(&:timestamp)
    slim :performances
  end

  get '/service_class_states' do
    @service_class_states = StvWlmServiceClassState.all
    slim :service_class_state
  end

  get '/users' do
    @users = PgUser.find_with_summary
    slim :users
  end

  get '/errors' do
    @errors = StlError.find_join_user
    slim :errors
  end
end

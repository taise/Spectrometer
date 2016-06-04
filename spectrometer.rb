require 'sinatra/base'
require 'sinatra/reloader'

class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    'Hello Spectrometer'
  end
end

require 'sinatra/base'

module Sinatra
  module CosmeticHelper
    def short_name(name)
      name.size > 24 ? name[1..24] + '...' : name
    end
  end
end

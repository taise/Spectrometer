module Sinatra
  module CosmeticHelper
    def short_name(name)
      name.size > 24 ? name[1..24] + '...' : name
    end

    def local_timestamp(time_str)
      Time.parse(time_str).local_timestamp
    rescue
      nil
    end
  end
end

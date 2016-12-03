# frozen_string_literal: true
require 'yaml'
require 'active_record'

class RedshiftBase
  CONFIG = YAML.load_file('./config/database.yml')[ENV['RACK_ENV']]
  ActiveRecord::Base.establish_connection(CONFIG)

  def self.connection
    ActiveRecord::Base.connection
  end

  def self.execute(sql)
    connection.execute(sql)
  end
end

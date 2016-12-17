# frozen_string_literal: true
require_relative 'sql'

class Redshift
  CONFIG = YAML.load_file('./config/database.yml')[ENV['RACK_ENV']]
  ActiveRecord::Base.establish_connection(CONFIG)

  def self.connection
    ActiveRecord::Base.connection
  end

  def self.execute(sql)
    connection.execute(sql)
  end

  def self.execute_text(name)
    execute(SQL.text(name))
  end
end

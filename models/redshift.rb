# frozen_string_literal: true
require_relative 'sql'
require 'pg'

class Redshift
  CONFIG = YAML.load_file('./config/database.yml')[ENV['RACK_ENV']]

  def self.connection
    ActiveRecord::Base.connection
  end

  def self.execute(sql)
    connection = PGconn.open(CONFIG)
    connection.exec(sql)
  end

  def self.execute_text(name)
    execute(SQL.text(name))
  end
end

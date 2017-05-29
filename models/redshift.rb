# frozen_string_literal: true
require_relative 'sql'
require 'pg'

class Redshift
  CONFIG = {
    host:     ENV['REDSHIFT_HOST'],
    port:     ENV['REDSHIFT_PORT'],
    dbname:   ENV['REDSHIFT_DBNAME'],
    user:     ENV['REDSHIFT_UESR'],
    password: ENV['REDSHIFT_PASSWORD']
  }

  def self.connection
    PGconn.open(CONFIG)
  end

  def self.execute(sql)
    connection.exec(sql)
  end

  def self.execute_text(name)
    execute(SQL.text(name))
  end

  def self.user
    CONFIG[:user]
  end

  def self.password
    CONFIG[:password]
  end
end

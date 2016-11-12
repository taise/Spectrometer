# frozen_string_literal: true
require 'yaml'
require 'active_record'

class Redshift < ActiveRecord::Base
  self.abstract_class = true
  config = YAML.load_file('./config/database.yml')
  establish_connection config[ENV['RACK_ENV']]

  # slice is defined by Active Record.
  def self.instance_method_already_implemented?(method_name)
    super(method_name)
  rescue ActiveRecord::DangerousAttributeError
    true
  end
end

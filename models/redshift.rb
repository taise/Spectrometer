# frozen_string_literal: true
require 'yaml'
require 'active_record'

class Redshift < ActiveRecord::Base
  self.abstract_class = true
  config = YAML.load_file('./config/database.yml')
  establish_connection config['development']
end

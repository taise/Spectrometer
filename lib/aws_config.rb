# frozen_string_literal: true
require 'yaml'
require 'aws-sdk'

class AwsConfig
  def self.valid?
    %w(
      region
      cluster_identifier
      aws_access_key_id
      aws_secret_access_key
    ).map { |key| CONFIG.key? key }
      .reduce { |bool, value| bool & value }
  end

  CONFIG = YAML.load_file('./config/aws.yml')
  raise 'Aws config validation error' unless valid?

  class << self
    def region
      CONFIG['region']
    end

    def cluster_identifier
      CONFIG['cluster_identifier']
    end

    def credentials
      Aws::Credentials.new(
        CONFIG['aws_access_key_id'],
        CONFIG['aws_secret_access_key']
      )
    end
  end
end

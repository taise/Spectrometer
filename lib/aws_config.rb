# frozen_string_literal: true

class AwsConfig
  def self.valid?
    %i(
      region
      cluster_identifier
      access_key_id
      secret_access_key
    ).map { |key| CONFIG.key? key }
      .reduce { |bool, value| bool & value }
  end

  CONFIG = {
    region: ENV['REGION'],
    cluster_identifier: ENV['CLUSTER_IDENTIFIER'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
  raise 'Aws config validation error' unless valid?

  class << self
    def region
      CONFIG[:region]
    end

    def cluster_identifier
      CONFIG[:cluster_identifier]
    end

    def credentials
      Aws::Credentials.new(
        CONFIG[:access_key_id],
        CONFIG[:secret_access_key]
      )
    end
  end
end

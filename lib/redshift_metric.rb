require 'aws-sdk'
require 'active_support'
require 'active_support/core_ext'


AWS_ACCESS_KEY_ID = 'hoge'.freeze
AWS_SECRET_ACCESS_KEY = 'piyo'.freeze

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
})


class RedshiftMetric

  # TODO: Read from config/aws.yml
  NAMESPACE = 'AWS/Redshift'.freeze
  DIMENSION_NAME = 'ClusterIdentifier'.freeze
  DIMENSION_VALUE = 'livesense-analytics'.freeze

  def initialize(name)
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, name)
  end

  def get_statistics(args = {})
    @metric.get_statistics(
      start_time: args['start_time'] || 12.hours.ago,
      end_time: args['end_time']     || Time.now,
      statistics: args['statistics'] || ['Average'],
      period: args['period']         || 60 * 10,
      dimensions: [
        {
          name:  DIMENSION_NAME,
          value: DIMENSION_VALUE
        }
      ]
    )
  end

  def name=(name)
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, name)
  end
end

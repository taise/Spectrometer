# frozen_string_literal: true
require './lib/aws_config'
require 'active_support'
require 'active_support/core_ext'

Aws.config.update(region: 'us-west-2',
                  credentials: AwsConfig.credentials)

class RedshiftMetric
  NAMESPACE = 'AWS/Redshift'
  DIMENSION_NAME = 'ClusterIdentifier'
  DIMENSION_VALUE = AwsConfig.cluster_identifier

  def initialize(name)
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, name)
  end

  def get(args = {})
    @metric.get_statistics(
      start_time: args[:start_time] || 12.hours.ago,
      end_time: args[:end_time]     || Time.now,
      statistics: args[:statistics] || ['Average'],
      period: args[:period]         || 60 * 10,
      dimensions: [
        {
          name:  DIMENSION_NAME,
          value: DIMENSION_VALUE
        }
      ]
    ).datapoints
  end

  def average
    # get Average statistics & return data matrix
    get(statistics: ['Average']).map { |dp| [dp.timestamp, dp.average] }
  end

  def max_by_1_min
    # get Average statistics & return data matrix
    get(start_time: 2.hours.ago, statistics: ['Maximum'], period: 60).map do
      |dp| [dp.timestamp, dp.maximum]
    end
  end

  def name=(name)
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, name)
  end
end

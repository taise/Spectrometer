# frozen_string_literal: true
require_relative 'aws_config'

class RedshiftMetric
  Aws.config.update(region: 'us-west-2', credentials: AwsConfig.credentials)

  NAMESPACE = 'AWS/Redshift'
  DIMENSION_NAME = 'ClusterIdentifier'
  DIMENSION_VALUE = AwsConfig.cluster_identifier

  attr_reader :name
  def initialize(name)
    @name = name
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, @name)
  end

  def get(args = {})
    @metric.get_statistics(
      start_time: args[:start_time].presence || 12.hours.ago,
      end_time: args[:end_time].presence     || Time.now,
      statistics: args[:statistics].presence || ['Average'],
      period: args[:period].presence         || 60 * 10,
      dimensions: [
        {
          name:  DIMENSION_NAME,
          value: DIMENSION_VALUE
        }
      ]
    ).datapoints
  end

  def average_list(args = {})
    get(args).map { |dp| [dp.timestamp, dp.average] }
  end

  def max_list(args = {})
    args = args.merge({ statistics: ['Maximum']})
    get(args).map { |dp| [dp.timestamp, dp.maximum] }
  end

  def name=(name)
    @metric = Aws::CloudWatch::Metric.new(NAMESPACE, name)
  end
end

# frozen_string_literal: true

require 'yaml'
require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'chartkick'

require './lib/redshift_metric'
require './lib/time'

$LOAD_PATH << './models'
require 'redshift'
require 'pg_user'
require 'stl_error'
require 'stl_query'
require 'stv_inflight'
require 'stv_wlm_service_class_state'
require 'svl_qlog'
require 'svl_statementtext'
require 'svv_table_info'

ENV['TZ'] = 'Asia/Tokyo'

class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    slim :index
  end

  get '/performances' do
    # TODO: async requests to Aws::CloudWatch::Metric
    slim :performances
  end

  get '/performances_short' do
    # TODO: async requests to Aws::CloudWatch::Metric
    slim :performances_short
  end

  get '/service_class_states' do
    @service_class_states = StvWlmServiceClassState.all
    slim :service_class_state
  end

  get '/stats_queries' do
    @queries_per_minute = StlQuery.queries_per_minute
    @queries_per_10_minutes = StlQuery.queries_per_10_minutes
    slim :stats_queries
  end

  get '/inflight_queries' do
    @queries = StvInflight.find_running_queries
    slim :inflight_queries
  end

  get '/slow_queries' do
    @queries = SvlQlog.find_slow_queries
    slim :slow_queries
  end

  get '/detail_query/:xid' do |xid|
    queries = SvlStatementtext.find_query_full_text(xid)
    @query = queries.first
    @sql = queries.map(&:text).reduce('') { |sql, text| sql + text }.gsub('\\n', "\r")
    slim :detail_query
  end

  get '/stats_off' do
    @tables = SvvTableInfo.find_stats_off
    slim :stats_off
  end

  get '/users' do
    @users = PgUser.find_with_summary
    slim :users
  end

  get '/errors' do
    @errors = StlError.find_join_user
    slim :errors
  end

  def self.new(*)
    # login user/pass == database user/pass
    db = YAML.load_file('config/database.yml')[ENV['RACK_ENV']]
    app = Rack::Auth::Digest::MD5.new(super) do |username|
      { db['username'] => db['password'] }[username]
    end
    app.realm = 'Protected Area'
    app.opaque = 'secretkey'
    app
  end
end

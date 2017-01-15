# frozen_string_literal: true

Bundler.require
require 'active_support/core_ext'

require_relative 'lib/redshift_metric'
require_relative 'helpers/cosmetic_helper'
require_relative 'models/redshift'

# Spectator Controller
class Spectrometer < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  helpers Sinatra::CosmeticHelper

  get '/' do
    redirect '/performances'
  end

  get '/performances' do
    # TODO: async requests to Aws::CloudWatch::Metric
    @args = {
      start_time: params['start_time'],
      period:     params['period']
    }
    slim :performances
  end

  get '/schema_tables' do
    @schema_tables = Redshift.execute_text('schema_tables.sql')
    slim :schema_tables
  end

  get '/tables/:id' do |id|
    # TODO: SQL injection prevention
    sql = SQL.text('table_info.sql').sub('__table_id__', id)
    @table = Redshift.execute(sql).first

    sql = SQL.text('table_defs.sql')
             .sub('__schema__', @table['schema'])
             .sub('__tablename__', @table['tablename'])
    @table_defs = Redshift.execute(sql)
    slim :table_info
  end

  get '/query_timelines' do
    @queries = Redshift.execute_text('query_timelines.sql')
    slim :'queries/query_timelines'
  end

  get '/service_class_states' do
    @service_class_states = Redshift.execute_text('service_class_states.sql')
    slim :service_class_state
  end

  get '/stats_queries' do
    @queries_1m = Redshift.execute_text('stats_queries_1m.sql')
    @queries_10m = Redshift.execute_text('stats_queries_10m.sql')
    slim :'queries/stats_queries'
  end

  get '/inflight_queries' do
    @queries = Redshift.execute_text('inflight_queries.sql')
    slim :'queries/inflight_queries'
  end

  get '/slow_queries' do
    @queries = Redshift.execute_text('slow_queries.sql')
    slim :'queries/slow_queries'
  end

  get '/detail_query/:id' do |xid|
    # TODO: SQL injection prevention
    sql = SQL.text('detail_query.sql').sub('__xid__', xid)
    queries = Redshift.execute(sql)

    @query = queries.first
    @sql_group = queries.group_by { |q| q['starttime'] }
    @sql = queries.map { |q| q['text'] }
                  .reduce('') { |sql, text| sql + text }
                  .gsub('\\n', "\r")
    slim :'queries/detail_query'
  end

  get '/stats_off' do
    @tables = Redshift.execute_text('stats_off.sql')
    slim :stats_off
  end

  get '/users' do
    @users = Redshift.execute_text('users.sql')
    slim :users
  end

  get '/errors' do
    @errors = Redshift.execute_text('errors.sql')
    slim :errors
  end

  get '/stl_load_errors' do
    @errors = Redshift.execute_text('stl_load_errors.sql')
    slim :stl_load_errors
  end

  get '/admin/vacuum_results' do
    @tables = Redshift.execute_text('vacuum_results.sql')
    slim :'admin/vacuum_results'
  end

  get '/admin/cluster_restart' do
    @queries = Redshift.execute_text('cluster_restart.sql')
    slim :'admin/cluster_restart'
  end

  post '/cancel' do
    conn = Redshift.connection
    redirect '/' if params[:pid].nil?

    # TODO: SQL injection prevention
    p Redshift.execute("CANCEL #{params[:pid]}")
    redirect '/inflight_queries'
  end

  def self.new(*)
    # login user/pass == database user/pass
    db = YAML.load_file('config/database.yml')[ENV['RACK_ENV']]
    app = Rack::Auth::Digest::MD5.new(super) do |username|
      { db['user'] => db['password'] }[username]
    end
    app.realm = 'Protected Area'
    app.opaque = 'secretkey'
    app
  end
end

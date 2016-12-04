# frozen_string_literal: true

require 'yaml'
require 'sinatra/base'
require 'sinatra/reloader'
require 'active_support'
require 'active_support/core_ext'
require 'slim'
require 'chartkick'

require './lib/redshift_metric'
require './lib/time'
require './helpers/cosmetic_helper'

$LOAD_PATH << './models'
require 'redshift'
require 'redshift_base'
require 'sql'
require 'stv_inflight'

ENV['TZ'] = 'Asia/Tokyo'
# Spectator Controller
class Spectrometer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers Sinatra::CosmeticHelper

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

  get '/schema_tables' do
    @schema_tables = RedshiftBase.execute(SQL.text('schema_tables.sql'))
    slim :schema_tables
  end

  get '/tables/:id' do |id|
    conn = RedshiftBase.connection
    table_id = conn.quote(id)
    sql = SQL.text('table_info.sql').sub('__table_id__', table_id)
    @table = conn.select_all(sql).first

    sql = SQL.text('table_defs.sql')
             .sub('__schema__', @table['schema'])
             .sub('__tablename__', @table['tablename'])
    @table_defs = conn.select_all(sql)
    slim :table_info
  end

  get '/query_timelines' do
    @queries = RedshiftBase.execute(SQL.text('query_timelines.sql'))
    slim :query_timelines
  end

  get '/service_class_states' do
    @service_class_states = RedshiftBase.execute(SQL.text('service_class_states.sql'))
    slim :service_class_state
  end

  get '/stats_queries' do
    @queries_1m = RedshiftBase.execute(SQL.text('stats_queries_1m.sql'))
    @queries_10m = RedshiftBase.execute(SQL.text('stats_queries_10m.sql'))
    slim :stats_queries
  end

  get '/inflight_queries' do
    @queries = StvInflight.find_running_queries
    slim :inflight_queries
  end

  get '/slow_queries' do
    @queries = RedshiftBase.execute(SQL.text('slow_queries.sql'))
    slim :slow_queries
  end

  get '/detail_query/:id' do |id|
    conn = RedshiftBase.connection
    xid = conn.quote(id)
    sql = SQL.text('detail_query.sql').sub('__xid__', xid)
    queries = conn.execute(sql)

    @query = queries.first
    @sql = queries.map { |q| q['text'] }
                  .reduce('') { |sql, text| sql + text }
                  .gsub('\\n', "\r")
    slim :detail_query
  end

  get '/stats_off' do
    @tables = RedshiftBase.execute(SQL.text('stats_off.sql'))
    slim :stats_off
  end

  get '/users' do
    @users = RedshiftBase.execute(SQL.text('users.sql'))
    slim :users
  end

  get '/errors' do
    @errors = RedshiftBase.execute(SQL.text('errors.sql'))
    slim :errors
  end

  get '/stl_load_errors' do
    @errors = RedshiftBase.execute(SQL.text('stl_load_errors.sql'))
    slim :stl_load_errors
  end

  get '/admin/vacuum_results' do
    @tables = RedshiftBase.execute(SQL.text('vacuum_results.sql'))
    slim :'admin/vacuum_results'
  end

  get '/admin/cluster_restart' do
    @queries = RedshiftBase.execute(SQL.text('cluster_restart.sql'))
    slim :'admin/cluster_restart'
  end

  post '/cancel' do
    pid = params[:pid]
    redirect '/' if pid.nil?
    StvInflight.cancel(pid)
    redirect '/inflight_queries'
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

workers 1
threads_count = 5
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 4567
environment ENV['RACK_ENV'] || 'development'
plugin :tmp_restart

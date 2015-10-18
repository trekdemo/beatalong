environment ENV['RACK_ENV']
port        Integer(ENV['PORT'] || 3000)
workers     Integer(ENV['WEB_CONCURRENCY'] || 2)
threads     2,4
rackup      DefaultRackup

preload_app!

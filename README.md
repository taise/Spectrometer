# Spectrometer

AWS Redshift monitoring web console.

![screenshot](https://raw.githubusercontent.com/taise/Spectrometer/images/spectrometer_ss.png)

## Features

- Performance metrics(AWS CloudWatch)
- Admin views
    - WLM queue state
    - Inflight queries
    - Table list & definitions
    - Slow queries
    - Error list


## Built with

- Ruby (2.3)
    - Sinatra
- Bulma (CSS Framework)
- AWS Redshift

## Set up

1. Clone Spectrometer

  ```
  git clone https://github.com/taise/Spectrometer.git
  ```

2. Set `.env`

  This user needs superuser priviledges.

  ```
  cd /path/to/project
  cp .env.sample .env
  ```

## Service Start (local)

1. Bundle install

  ```
  gem install bundler
  bundle install --path vendor/bundle
  ```

2. Start

  ```
  bundle exec rackup -p 9292
  ```

## Service Start (docker)

1. build image

  ```
  docker build -t ruby:2.3-alpine-spectrometer .
  ```

2. Start

  ```
  docker run -it -p 9292:9292 ruby:2.3-alpine-spectrometer
  ```


## Access

[http://localhost:9292](http://localhost:9292)  
Login username & password are set `config/database.yml`.


## License

MIT license

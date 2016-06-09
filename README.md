# Spectrometer

AWS Redshift monitoring web console.

## Features

* WLM queue state
* pg_user list
* error list


## Roadmap

* Metrics dashboard from AWS CloudWatch
* Check slow query & notification
* Chack overflowing WLM queue & notification
* Authentication


## Built With

* Ruby
* Sinatra
* Bulma (CSS Framework)
* AWS Redshift


## Installation (local)

1. Clone Spectrometer

```
git clone https://github.com/taise/Spectrometer.git
```

2. Set `config/database.yml`

```
cd /path/to/project
cp config/database.yml.sample config/database.yml
```

3. Bundle install

```
gem install bundler
bundle install --path vendor/bundle
```

4. Service start

```
bundle exec rackup
```


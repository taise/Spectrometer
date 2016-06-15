# Spectrometer

AWS Redshift monitoring web console.

![screenshot](https://raw.githubusercontent.com/taise/Spectrometer/images/spectrometer_ss.png)

## Features

* Redshift performance metrics by AWS CloudWatch
* WLM queue state
* pg_user list
* error list


## Roadmap

### Next Architecture

* Reads the data regularly from Redshift, write to sqlite3
* Show the data read from sqlite3 with ActiveRecord


### Next Features

* Check slow query & notification
* Chack overflowing WLM queue & notification


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

3. Set `config/aws.yml`

  ```
  cp config/aws.yml.sample config/aws.yml
  ```

4. Bundle install

  ```
  gem install bundler
  bundle install --path vendor/bundle
  ```

5. Service start

  ```
  bundle exec rackup -p 9292
  ```

6. Access

  [http://localhost:9292](http://localhost:9292)

7. Login

  The login username/passwords, those `config/database.yml` is set.


## License

MIT license

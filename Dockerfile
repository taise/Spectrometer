FROM ruby:2.3-alpine

MAINTAINER taise <taise515@gmail.com>

# Sinatra App
ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
COPY . $APP_ROOT
RUN set -ex \
  && apk --update add --no-cache \
            ruby-dev \
            postgresql-dev \
  && apk add --no-cache --virtual=ruby-bundle-deps \
            git \
            make \
            g++ \
  && cd $APP_ROOT \
  && bundle config git.allow_insecure true \
  && bundle install \
  && apk del ruby-bundle-deps

CMD bundle exec rackup -p 9292 -o 0.0.0.0 -E production

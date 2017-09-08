# FROM ruby:2.4-slim
FROM joshdvir/ruby-jemalloc

WORKDIR /app

ENV PACKAGES \
  build-essential

RUN apt-get update && apt-get install --no-install-recommends -y $PACKAGES
COPY Gemfile Gemfile.lock /app/

RUN bundle install

COPY . /app

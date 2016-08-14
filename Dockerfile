# image and default installs
FROM ruby:2.2.2

WORKDIR /usr/src/app
ADD Gemfile      /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock
RUN bundle install

ADD . /usr/src/app

CMD bundle exec puma --config config/puma.rb

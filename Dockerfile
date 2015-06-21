FROM ruby:2.2.2

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

ENV APP_HOME /waldorfcamp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
RUN bundle install

ENV RACK_ENV production

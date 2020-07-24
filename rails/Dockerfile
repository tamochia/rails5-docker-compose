FROM ruby:2.6.5-slim
ENV LANG C.UTF-8
RUN apt-get update -qq && \
    apt-get install -y build-essential curl tzdata git \
    default-libmysqlclient-dev libmariadb-dev mariadb-client \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key  add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn
ENV APP_ROOT /opt/sample_app
WORKDIR $APP_ROOT
COPY src/Gemfile $APP_ROOT/Gemfile
COPY src/Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
COPY src $APP_ROOT
RUN mkdir -p $APP_ROOT/tmp/sockets && \
    mkdir -p $APP_ROOT/tmp/pids && \
    touch $APP_ROOT/tmp/sockets/.keep && \
    touch $APP_ROOT/tmp/pids/.keep

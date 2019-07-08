FROM ruby:2.4

ENV http_proxy="http://proxy-us.intel.com:911"
ENV https_proxy="http://proxy-us.intel.com:912"
ENV no_proxy="intel.com,.intel.com,localhost,127.0.0.1,0.0.0.0"

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \
    nano \
    postgresql-client

RUN gem install bundler -v 2.0.1

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

RUN gem install rails

COPY .npmrc /root

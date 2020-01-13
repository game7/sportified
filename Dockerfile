
FROM ruby:2.6.3

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \
    nano \
    postgresql-client

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3    

RUN gem install rails:5.2.3 rake:13.0.1 bundler:2.1.4

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

# ------------------------------------------------------------------------------------------------------------
# base
# ------------------------------------------------------------------------------------------------------------
FROM ruby:2.6.3 as base

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \
    nano \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
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

RUN gem install \
    rails:5.2.3 \
    rake:13.0.1 \
    bundler:2.1.4

# ------------------------------------------------------------------------------------------------------------
# development
# ------------------------------------------------------------------------------------------------------------
FROM base as development

# Copy library scripts to execute
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    # && apt-get purge -y imagemagick imagemagick-6-common \
    # Install common packages, non-root user, rvm, core build tools
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # && bash /tmp/library-scripts/ruby-debian.sh "none" "${USERNAME}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# # [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="none"
# ENV NVM_DIR=/usr/local/share/nvm
# ENV NVM_SYMLINK_CURRENT=true \
#     PATH=${NVM_DIR}/current/bin:${PATH}
# RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
#     && apt-get clean -y && rm -rf /var/lib/apt/lists/*

 # Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install additional gems.
# RUN gem install <your-gem-names-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

RUN gem install \
    foreman \
    rubocop \
    rubocop-rails \
    solargraph

# install heroku cli
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# ------------------------------------------------------------------------------------------------------------
# production
# ------------------------------------------------------------------------------------------------------------

# tbd
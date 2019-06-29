FROM alpine:3.10

LABEL maintenar "katsuya sugawara"

ENV APP_ROOT /var/www/html/app
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.5.1

ENV UNICORN_ENV production
ENV UNICORN_PID_PATH /var/run/unicorn
ENV UNICORN_LOG_PATH /var/log/unicorn
ENV UNICORN_WORKER_PROCESSES 2
ENV UNICORN_TIMEOUT 300
# unicorn socket type.
# if you would like to use unix socket, you can use it to change ENV param from INET to UNIX
ENV UNICORN_SOCKET_TYPE INET

# preparation
RUN mkdir -p ${APP_ROOT} ${UNICORN_PID_PATH} ${UNICORN_LOG_PATH}
RUN addgroup unicorn \
 && adduser -DG unicorn unicorn
RUN chown -R unicorn: ${APP_ROOT} ${UNICORN_PID_PATH} ${UNICORN_LOG_PATH}

# for rbenv and ruby setting
RUN apk add --update \
  bash \
  git \
  wget \
  curl \
  vim \
  build-base \
  readline-dev \
  openssl-dev \
  zlib-dev \
  linux-headers \
  imagemagick-dev \
  libffi-dev \
 && rm -rf /var/cache/apk/*

RUN git clone --depth 1 git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} \
 && git clone --depth 1 https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
 && git clone --depth 1 git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset \
 && ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN rbenv install $RUBY_VERSION \
 && rbenv global $RUBY_VERSION

RUN gem install bundler unicorn

# for default unicorn setting
USER unicorn
ADD ./app ${APP_ROOT}
WORKDIR ${APP_ROOT}
RUN if [ -e 'Gemfile' ]; then bundle install --path vendor/bundle; fi

# port setting
EXPOSE 3000

# volume setting
VOLUME ${UNICORN_LOG_PATH}

ENTRYPOINT bundle exec unicorn -c ${APP_ROOT}/config/unicorn.rb -E ${UNICORN_ENV}

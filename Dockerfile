FROM ruby:2.7.0

RUN apt-get update \
  && apt-get install -y \
  nodejs \
  bash \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.1.4

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

COPY ./entrypoints/docker-entrypoint.sh /usr/bin
COPY ./entrypoints/sidekiq-entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/sidekiq-entrypoint.sh


EXPOSE 3000
ENTRYPOINT [ "docker-entrypoint.sh" ]
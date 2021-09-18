FROM ruby:2.7.0

RUN apt-get update \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.1.4

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

COPY docker/entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000
ENTRYPOINT [ "entrypoint.sh" ]
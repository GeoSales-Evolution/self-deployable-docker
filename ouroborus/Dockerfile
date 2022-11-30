FROM ruby:3-alpine
WORKDIR /app
EXPOSE 8000
RUN bundle config --global frozen 1
COPY Gemfile Gemfile.lock ouroborus.gemspec /app/
RUN bundle install
COPY lib/ /app/lib/
COPY bin/ /app/bin/
RUN bundle install
CMD bundle exec ouroborus

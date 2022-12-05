FROM ruby:3-alpine as build
WORKDIR /app
RUN apk update && apk add git
RUN bundle config --global frozen 1
COPY Gemfile Gemfile.lock ouroborus.gemspec /app/
RUN bundle package --all

# Start the second stage build
FROM ruby:3-alpine
EXPOSE 8000
WORKDIR /app 
RUN apk update && apk add docker

#Copying webrick gem already pulled from git
COPY --from=build /app /app

COPY lib/ /app/lib/
COPY bin/ /app/bin/

RUN bundle install --local
EXPOSE 8000
CMD bundle exec ouroborus

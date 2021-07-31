FROM ruby:3.0-alpine
ENV APP_PATH="/fetch"
WORKDIR $APP_PATH
COPY . ./
RUN gem install nokogiri:1.11.2 parallel:1.20.1

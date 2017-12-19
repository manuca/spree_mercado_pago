FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev pngquant locales nodejs

RUN mkdir /myapp
WORKDIR /myapp

ENV BUNDLE_PATH /myapp/.bundle

# Set the locale
RUN locale-gen C.UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

## We need this as is the base mont point
ADD . /myapp

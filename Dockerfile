# syntax=docker/dockerfile:1
# check=error=true

# --- Stage 1: Base Image and Dependencies ---
ARG RUBY_VERSION=3.4.7
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /app

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        curl \
        postgresql-client \
        libpq-dev \
        build-essential \
        nodejs \
        libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Throw-away build stage to reduce size of final image
FROM base AS development

# Install application gems
COPY Gemfile Gemfile.lock /app/

RUN bundle install

COPY . /app/

# Start server, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
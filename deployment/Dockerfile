FROM ruby:3.1.2

WORKDIR /api

COPY . /api

# Installs dependencies to be able to start the server
RUN gem install bundler && bundle install
# Exposes the port of the rake application to the outside
EXPOSE 80

ENTRYPOINT ["deployment/entrypoint.sh"]
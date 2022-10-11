FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y curl postgresql-client cmake
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN apt-get update && apt-get install -y ffmpeg
# Needed for PDF preview. In Heroku is available with
# `heroku buildpacks:add -i 1 https://github.com/heroku/heroku-buildpack-activestorage-preview`
RUN apt-get install -y vim nano
RUN npm i -g yarn@1.19.1

RUN mkdir /myapp
WORKDIR /myapp

# Install all the gems needed
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
EXPOSE 6006

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

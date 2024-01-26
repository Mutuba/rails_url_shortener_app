# Dockerfile development version
FROM ruby:3.2.2

RUN apt-get update -qq --allow-insecure-repositories && apt-get install -y curl postgresql-client cmake

RUN apt-get update && apt-get install -y nodejs
RUN apt-get update && apt-get install -y ffmpeg

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

RUN apt-get install -y vim nano

RUN mkdir /app
WORKDIR /app

# Install all the gems needed
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

RUN bundle binstubs --all

RUN touch $HOME/.bashrc

RUN echo "alias ll='ls -alF'" >> $HOME/.bashrc
RUN echo "alias la='ls -A'" >> $HOME/.bashrc
RUN echo "alias l='ls -CF'" >> $HOME/.bashrc
RUN echo "alias q='exit'" >> $HOME/.bashrc
RUN echo "alias c='clear'" >> $HOME/.bashrc

COPY . /app

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start server
CMD ["rails", "server", "-b", "0.0.0.0", "/bin/bash"]
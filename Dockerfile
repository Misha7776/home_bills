FROM ruby:2.7.0

# List of folders on not required for production
ARG FOLDERS_TO_REMOVE="spec node_modules vendor/assets lib/assets tmp/cache"
# add neset nodejs repo
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# add newest yarn repo
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

# Set an environment variable where the Rails app is installed to inside of Docker image
#ENV RAILS_ROOT /var/www/$APP_NAME

# make a new directory where our project will be copied
RUN mkdir -p /app

# Set working directory within container
WORKDIR /app

# Setting env up
ENV RAILS_ENV=$RAILS_ENV
ENV RAKE_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# development/production differs in bundle install
RUN gem install bundler
RUN if [[ "$RAILS_ENV" == "production" ]]; then\
  bundle install --jobs 20 --retry 5 --without development test;\
  else bundle install --jobs 20 --retry 5; fi

# Remove build dependencies and install runtime dependencies
# RUN apt install postgresql-client postgresql-libs nodejs tzdata

# Adding project files
COPY . .

RUN yarn install
RUN bundle exec rake assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf $FOLDERS_TO_REMOVE \

EXPOSE 3000
EXPOSE 5432

# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
RUN ["chmod", "+x", "./docker/app/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "./docker/app/docker-entrypoint.sh"]

FROM ruby:3.4.4

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

VOLUME /app

# Expose port for Rails server
EXPOSE 3000

CMD ["bin/dev"]

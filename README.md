# health-check.backend

## Things required:
1. Ruby : https://github.com/postmodern/chruby
2. Bundler : gem install bundler
3. Redis : 
         - OSX : brew install redis
         - Ubuntu : https://redis.io/topics/quickstart
         

## To get started

run `bundle install` to get all the gems installed 

## To start the application:

`foreman start` 
or
`rackup` / `shotgun` to start the app server
- bundle exec sidekiq -C ../lib/sidekiq-worker -q check -v

## To open the Application:

Based on the app server used, `http://localhost:<port-number>` to open the app.

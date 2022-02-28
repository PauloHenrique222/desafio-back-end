web: bundle exec bin/rails server -p $PORT -e $RAILS_ENV
redis: redis-server
worker: bundle exec sidekiq -C config/sidekiq.yml
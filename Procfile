release: bash ./release.sh
# web: puma -C config/puma.rb
web: bundle exec puma -C config/puma_heroku.rb
# worker: bundle exec sidekiq -e production -C config/sidekiq.yml
worker: bundle exec sidekiq -c 5

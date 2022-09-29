release: bash ./release.sh
web: puma -C config/puma.rb
worker: bundle exec sidekiq -e production -C config/sidekiq.yml
# worker: bundle exec sidekiq -c 5

release: bash ./release.sh
# worker: bundle exec sidekiq -c 5 -v
web: puma -C config/puma.rb
# worker: bundle exec sidekiq -e production -C config/sidekiq.yml
worker: bundle exec sidekiq -t 25 -c ${SIDEKIQ_CONCURRENCY:-5}

web: bundle exec puma -C config/puma.rb
resque: TERM_CHILD=1 QUEUE=* bundle exec rake environment resque:work
scheduler: TERM_CHILD=1 bundle exec rake environment resque:scheduler

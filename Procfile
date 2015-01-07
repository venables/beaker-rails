web: unicorn -p $PORT -c ./config/unicorn.rb
resque: TERM_CHILD=1 QUEUE=* rake environment resque:work
scheduler: TERM_CHILD=1 rake environment resque:scheduler

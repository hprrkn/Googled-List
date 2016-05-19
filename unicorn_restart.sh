#!/bin/sh

#unicorn stop
cat /home/prrknh/SinatraApp/GoogledListBySinatra/tmp/pids/unicorn.pid | xargs kill -QUIT
#unicorn start
bundle exec unicorn -E development -c unicorn.rb -D

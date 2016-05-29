#!/bin/sh

case $1 in
    'status')
        if [ -e ./tmp/pids/unicorn.pid ];
        then
            echo 'unicorn is runnning'
        else
            echo 'unicorn is stopped'
        fi
        ;;
    'start')
        if [ -e ./tmp/pids/unicorn.pid ];
        then
            echo 'unicorn is already running'
        else
            bundle exec unicorn -E development -c unicorn.rb -D
            echo 'unicorn start now'
        fi
        ;;
    'stop')
        if [ -e ./tmp/pids/unicorn.pid ] ;
        then
           cat ./tmp/pids/unicorn.pid | xargs kill -QUIT
           echo 'unicorn has stopped'
        else
           echo 'unicorn is stopped'
        fi
        ;;
    'restart')
        if [ -e ./tmp/pids/unicorn.pid ] ;
        then
           cat ./tmp/pids/unicorn.pid | xargs kill -QUIT
           bundle exec unicorn -E development -c unicorn.rb -D
        else
           echo 'unicorn is stopped, plese set option [start]'
        fi
        ;;
    '*')
        echo 'plese set option'
        echo 'status / start / stop'
        ;;
esac

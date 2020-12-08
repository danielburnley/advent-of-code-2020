#!/bin/sh

while inotifywait -e close_write lib/solutions/day_$1.rb; do bundle exec ruby lib/solutions/day_$1.rb; done
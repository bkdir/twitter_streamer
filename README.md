# == Twitter Observer - basic ==

Uses Twitter's streaming api to keep track of followed users' actions. Displays information about deleted tweet&media.

## Getting started

1. bundle install --without production
2. rails db:migrate
3. rails test
4. rails server

### To start saving tweets&media:
1. Update config/secrets.yml file.

2.`rails runner bin/twitter_observer.rb`

### Additional information:
* Ruby v2.2.5
* Rails v5.0.0.1

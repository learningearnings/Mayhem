Project Mayhem
=====

Ruby On Rails reimplementation of LearningEarnings.com

### Development
Fork, then clone the repository to your development environment

    gem install bundler
    bundle install
    rake db:reset db:test:clone test

Run guard to run the tests as you develop:

    bundle exec guard

Then when you change files, tests will run.

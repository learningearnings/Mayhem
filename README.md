Project Mayhem
=====

Ruby on Rails reimplementation of LearningEarnings.com.

### Multi-Domain Spree **** IMPORTANT ****

We're using multi-domain Spree, and that means that every school has it's own domain.
Currently, we're using the schools id as the domain, so the domain would be (for localhost development)

    1.localhost:3000

This requires that you put 1.localhost in your hosts file.

If you do not want to manually update your hosts file for development, you can use [Pow](http://pow.cx) for Mac OS X or [Prax](https://github.com/ysbaddaden/prax) for Linux.

Once installed, you should be able to visit **mayhem.dev** and subdomains work out of the box.

### New Spree and custom Order flow
 * Upgraded to Spree 1.2.0
 * Upgraded to spree-multi-domain master fork of learningearnings (needed a patch)
 * Order flow is as follows
   * cart
   * transmitted (Sent to LE for fulfillment)  (only global and wholesale purchases stop here)
   * printed (Printed by LE for fulfillment) (user can't edit the order at this point)
   * completed
   * shipped
   * refunded


### Development
Fork, then clone the repository to your development environment

    gem install bundler
    bundle install
    rake db:drop db:create:all db:migrate db:test:clone test

To start the Rails server

    bundle exec rails server

Run guard to run the tests as you develop:

    bundle exec guard

Then when you change files, tests will run.

To reset your database, create it, run migrations load seeds and samples run:
    rake le:reload!

that will kill any ruby and psql processes you have running and then db:drop db:create db:migrate db:seed

To load up some sample data, run:

    rake db:seed

To load up sample spree products, also run:

    rake spree_sample:load

Or, to load up some sample Learning Earnings products, do:
    rake db:load_dir[samples]

### Login Seed Info
    leadmin = username: 'leadmin', password: 'spree123'
    teacher = username: 'user 1', password: 'spree123'
    school_admin = username: 'schooladmin', password: 'spree123'
    student1 = username: 'student1', password: 'spree123'
    student2 = username: 'student2', password: 'spree123'

### Binary Dependencies
Below are a list of binary dependencies that the project uses:

#### wkhtmltopdf
Install via instructions [here](https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF).  We have to install 0.9.9 because of a bug in 0.11.0.rc1.

If you want to try it out, you'll have to run the app with unicorn and multiple workers.  There's a config already set up, just do this:

    unicorn_rails -c config/unicorn.conf # (from rails_root)

Then visit [this page](http://localhost:8080/pages/pdf.pdf) in the browser.


### Project Gems
Below are a list of 'important' gems that the project is utilizing:

#### CanCan
CanCan enables us to set up a file to declare what certain groups of users can and cannot do, then we are able to reference those restrictions throughout the site to simplify view logic. The Ability model is the file for configuring abilities, and is initially set up to restrict Teachers, Students, Parents, and LeAdmins.

https://github.com/ryanb/cancan

Assuming a Teacher can manage the site, the last statement here should be true:

    teacher = Teacher.create
    ability = Ability.new(teacher)
    message = teacher.messages.create
    ability.can?(:destroy, message)

Assuming a Student can only read the site, the last statement here should be false:

    student = Student.create
    ability = Ability.new(student)
    message = student.messages.create
    ability.can?(:destroy, message)

#### State Machine
State machine allows us to give a model a status field and keep track of that.

[https://github.com/pluginaweek/state_machine/](https://github.com/pluginaweek/state_machine/)

To Test out:

    a = Person.create
    a.status    # should equal 'new'
    a.activate
    a.status    # should now equal 'active'
    a.deactivate
    a.status    # should now equal 'inactive'

#### Plutus
Plutus is a General Ledger / Accounting engine that Isotope11 has contributed to and that we use in multiple projects.

Right now, you can hit /plutus (as anyone) to view the chart of accounts, balances, and transactions.  This is basic reporting provided out of the box by plutus, and can be useful.  We must lock this down before going into production

#### Account Names
* MAIN\_ACCOUNT(Liability)
  LE
* SCHOOL1 MAIN(Asset)
* SCHOOL1 CREDIT(Asset)
* SCHOOL ADMIN1(Asset)
* TEACHER2 MAIN SCHOOL1(Asset)
* TEACHER2 UNREDEEMED SCHOOL1(Asset)
* TEACHER2 UNDEPOSITED SCHOOL1(Asset)
* STUDENT4 CHECKING(Asset)
* STUDENT4 SAVINGS(Asset)
* STUDENT5 CHECKING(Asset)
* STUDENT5 SAVINGS(Asset)

#### Cron for Auction notifications(This one runs at 5 every day for now.)
    0,17,20,23 * * * export PATH=$PATH:/usr/local/bin/;bash -l -c 'cd /home/deployer/apps/Mayhem/current && script/rails runner -e production '\''AuctionHandler.new.run!'\'''

#### Deploying

##### Staging:

_initial setup:_

    cap staging deploy:setup

_no migrations:_

    cap staging deploy

_with migrations:_

    cap staging deploy:migrations

_roll it back:_

    cap staging deploy:rollback

### Rack Bug
To use rack-bug, first visit this page in your browser and drag the link from
the page content into your bookmarks toolbar:

    http://RAILS_APP/__rack_bug__/bookmarklet.html

Then visit the site in dev mode and click the bookmarklet.  Use the password: "Seriouslythoughthisisadebugkey"


## Troubleshooting

if you get an "access to remote repository failed on deploy" then your identities have been corrupted and you can do the following:
 $ ssh-add -D   #remove existing identities
 $ ssh-agent    #copy the lines & run them
 $ ssh-add      #uses the output from above






Project Mayhem
=====

Ruby On Rails reimplementation of LearningEarnings.com

### Multi-Domain Spree **** IMPORTANT ****

We're using multi-domain Spree, and that means that every school has it's own domain.
Currently, we're using the schools id as the domain, so the domain would be (for localhost development)

    1.localhost:3000

This requires that you put 1.localhost in your hosts file.   If your on the Interwebs, then you can use
the domain lvh.me (local virtual host - resolves to 127.0.0.1) which has a subdomain wildcard so *.lvh.me
resolves to 127.0.0.1

Everything might not be working right, but development from here on should use the below url:

    lvh.me:3000

The app now will try to redirect you to 1.lvh.me:3000 if you come in without a subdomain.

### Development
Fork, then clone the repository to your development environment

    gem install bundler
    bundle install
    rake db:drop db:create:all db:migrate db:test:clone test

Run guard to run the tests as you develop:

    bundle exec guard

Then when you change files, tests will run.

To load up some sample data, run:

    rake db:seed

To load up sample spree products, also run:

    rake spree_sample:load

Or, to load up some sample Learning Earnings products, do:
    rake db:load_dir[samples]

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

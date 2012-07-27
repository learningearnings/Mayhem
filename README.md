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

https://github.com/pluginaweek/state_machine/

To Test out:

    a = Person.create
    a.status    # should equal 'new'
    a.activate 
    a.status    # should now equal 'active'
    a.deactivate 
    a.status    # should now equal 'inactive'

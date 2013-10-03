# Mayhem Production Deploy Notes

## Initial setup
Create a new database for the day's import

```
postgres=# CREATE DATABASE learning_earnings_production_10_1;
CREATE DATABASE
postgres=# GRANT ALL PRIVILEGES ON DATABASE learning_earnings_production_10_1 to db_user;
GRANT
```

Seed:

```bash
RAILS_ENV=production bundle exec rake db:migrate db:seed
```

## Run the importers against the previously-extracted CSV files

First, in the bash console:

```bash
bundle exec rails c production
```

Next, run the CSV importers directly:

```ruby
i = Importers::Le::SchoolsImporter.new("/home/deployer/schools.csv")
i.call

i = Importers::Le::UsersImporter.new("/home/deployer/users.csv")
i.call

i = Importers::Le::ClassroomsImporter.new("/home/deployer/classrooms.csv")
i.call

i = Importers::Le::ClassroomDetailsImporter.new("/home/deployer/classroom_details.csv")
i.call

i = Importers::Le::StudentCheckingImporter.new("/home/deployer/checking_points.csv")
i.call

i = Importers::Le::StudentSavingImporter.new("/home/deployer/saving_points.csv")
i.call

i = Importers::Le::TeacherPointsImporter.new("/home/deployer/teacher_points.csv")
i.call
```


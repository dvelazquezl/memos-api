# README

# Description

# Requirements
* Rails 7.0.5
* Ruby 3.1.2
* MariaDB

# Database configuration
Create `config/database.yml` file out of `config/database-example.yml` and update the values for your user and password (this update is only needed for the development environment, for production go to the deploy to production section).

# Setup JWT secret key
You will need a secret key to be able to encrypt the user's passwords. 
Create `config/secrets.yml` file out of `config/secrets-example.yml` and update the values for development and production. In order to generate those keys you need to run `rails secret` for each environment.

# Run the project locally
```bash
# Setup database
rails db:create
rails db:migrate
rails db:seed
# Index database to solr server (in case there is already data there)
bundle exec rake sunspot:reindex # also works with rails sunspot:reindex
# Start server
rails server
```
After the server started you can go to your browser to this url: `http://localhost:3000` or use some application to make HTTP calls.

# Deploy the project to production
> These instructions are meant to be seated in a ubuntu server alongside nginx as a reverse proxy. You should be able to install nginx following this [instructions](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04).


You need to export the Database credentials as environment variables, so in your `~/.bashrc` or `~/.zshrc`, depending on your operating system and shell. Add the export commands to the end of the file.
```bash
export PROD_DB_USER=user
export PROD_DB_PASSWORD=password
```
Save the file and restart the terminal. Then you will need to setup the database:
```bash
RAILS_ENV=production rails db:create
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails db:seed
```
Then you need to create an admin user, this will be done through the console `rails console` and run the following (you can change the fields if you want):
```bash
usr = User.new(ci_number: 1234567, full_name: 'Admin', email: 'a valid email', username: 'admin', role: :admin, office_id: 1, password: 'password', password_confirmation: 'password');
usr.save!
quit
```
Then 
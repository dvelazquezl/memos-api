# README

# Description

# Requirements
* Rails 7.0.5
* Ruby 3.1.2
* MariaDB

# Database configuration
Create `config/database.yml` file out of `config/database-example.yml` and update the values.

# Setup JWT secret key
You will need a secret key to be able to encrypt the user's passwords. 
Create `config/secrets.yml` file out of `config/secrets-example.yml` and update the values for development and production. In order to generate those keys you need to run `rails secret` for each environment.

# Run the project locally
```bash
# Setup database
rails db:create
rails db:migrate
# Index database to solr server (in case there is already data there)
bundle exec rake sunspot:reindex
# Start server
rails server
```
After the server started you can go to your browser to this url: `http://localhost:3000` or use some application to make HTTP calls.
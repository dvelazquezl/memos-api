# Memos API
REST API built with Rails.
## Requirements
* Rvm 1.29.12
* Rails 7.0.5
* Ruby 3.1.2
* MariaDB >= 11.3.2

## How to run the project

### 1. Database configuration
Create `config/database.yml` file out of `config/database-example.yml` and update the values for your user and password for the environment you are going to work.
```bash
cp config/database-example.yml config/database.yml
```
Set your username and password for your database
```bash
# database.yml
username: USER
password: PASSWORD
```

### 2. Setup JWT secret key
You will need a secret key to be able to encrypt the user's passwords. 
Create `config/secrets.yml` file out of `config/secrets-example.yml` and generate the corresponding key for each environment  (local, production). In order to generate those keys you need to run `rails secret` for each environment and then copy the value to the `secrets.yml` file you already created.
```bash
cp config/secrets-example.yml config/secrets.yml
```
```bash
rvm use
rails secret

# secrets.yml
development:
  jwt_secret_key: your_key_from_rails_server

development:
  jwt_secret_key: your_key_from_rails_server
```

### 3. Install dependencies and initialize database
```bash
# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Index database to solr server
# Before running this you should have a running instance of Solr in your machine.
bundle exec rake sunspot:reindex # also works with rails sunspot:reindex
```
### 4. Create admin user
Enter the production console by running `rails console -e production` and run the following (you can change the fields if you want):
```bash
usr = User.new(ci_number: 1234567, full_name: 'Admin', email: 'a valid email', username: 'admin', role: :admin, office_id: 1, password: 'password', password_confirmation: 'password');
usr.save!
quit
```
### 5. Run the project
```bash
# Start server
rails server
```
After the server started you can go to your browser to this url: `http://localhost:3000` or use some application to make HTTP calls.

## Deploy to production
> These instructions are meant to be seated in an Ubuntu Server (Version >= 22.04) alongside Nginx, a high-performance web server and reverse proxy, and Passenger, a web and application server designed to manage and serve Ruby, Python, and Node.js applications efficiently.<br>You can find how to install all of those 2 technologies here:<br>[Install Nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04) (Setup the server blocks according to your domain)<br>[Install Passenger](https://www.phusionpassenger.com/docs/tutorials/deploy_to_production/installations/oss/ownserver/ruby/nginx/) (Skip installing nginx again).

### 1. Repeat the steps 1 and 2 for production environment
### 2. Install dependencies and initialize database
```bash
# Install dependencies
bundle install

# Setup database
rails db:create -e production
rails db:migrate -e production
rails db:seed -e production

# Index database to solr server
# Before running this you should have a running instance of Solr in your machine.
RAILS_ENV=production rails sunspot:reindex
```
### 3. Repeat step 4 and create an admin user
### 4. Configure passenger
Asumming you already created a server file for your domain in `/etc/nginx/sites-available/your-memos-api-domain`. Open that file and replace its content with this:
```bash
server {
    listen 80;
    server_name your-domain;

    root /var/www/your-domain/public;

    passenger_enabled on;
    passenger_app_env production;
    passenger_ruby /usr/share/rvm/gems/ruby-3.1.2/wrappers/ruby; # this could be different depending on where ruby its installed
}
```
### 5. Restart nginx service
```bash
sudo systemctl restart nginx.service
```
After this you should be able to go to http://your-memos-api-domain and get a status message like this:
```json
{"status":"API is up and running","commit":"comit-hash"}
```
### More info about deployment
* [Deploying a Ruby app on your own production server](https://www.phusionpassenger.com/docs/tutorials/deploy_to_production/deploying_your_app/oss/ownserver/ruby/nginx/)
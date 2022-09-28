# README

* Ruby Urls shortner app that accepts a csv file and uploads creating a batch containing all the url.

* The application uses action cable to broadcast upload progress to the UI.

* This application uses Ruby version 3.0.2 To install, use rvm or rbenv.

* RVM

`rvm install 3.0.2`

`rvm use 3.0.2`

* Rbenv

`rbenv install 3.0.2`

* Bundler provides a consistent environment for Ruby projects by tracking and installing 
the exact gems and versions that are needed. I recommend bundler version 2.0.2. To install:


* You need Rails. The rails version being used is rails version 7

* To install:

`gem install rails -v '~> 7'` 


*To get up and running with the project locally, follow the following steps.

* Clone the app

* With SSH

`git@github.com:Mutuba/rails_url_shortener_app.git`

* With HTTPS

`https://github.com/Mutuba/rails_url_shortener_app.git`


* Move into the directory and install all the requirements.

* cd rails_url_shortener_app

* run `bundle install` to install application packages

* Run `rails db:create` to create a database for the application

* Run `rails db:migrate` to run database migrations and create database tables

* The application can be run by running the below command:-

`rails s` or `rails server`

* The application uses redis and sidekiq for background job processing 
* Run this commands in separate terminals to start redis and sidekiq

`redis-server` to start redis server and bu`bundle exec sidekiq` to start sidekiq server

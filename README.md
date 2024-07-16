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

* The application uses redis and sidekiq for backgroun
d job processing 
* Run this commands in separate terminals to start redis and sidekiq

`redis-server` to start redis server and `bundle exec sidekiq` to start sidekiq server

Screenshots:

Urls page
<img width="1440" alt="Screenshot 2024-07-16 at 07 53 09" src="https://github.com/user-attachments/assets/7eb4ba04-4972-4ed7-9dd6-e5bf9616be97">


Batches page
<img width="1440" alt="Screenshot 2024-07-16 at 07 52 52" src="https://github.com/user-attachments/assets/75c5a6c7-9e4e-4fe3-9f13-aeb48af42c91">


CSV upload Page
<img width="1440" alt="Screenshot 2024-07-16 at 07 53 44" src="https://github.com/user-attachments/assets/7e0dbe9b-9d67-4625-9686-f58bfeac517d">


Upload Progress page

<img width="1440" alt="Screenshot 2024-07-16 at 07 54 10" src="https://github.com/user-attachments/assets/26875810-3781-4e58-9c94-6aed88c8d0e8">

Url update page
<img width="1440" alt="Screenshot 2024-07-16 at 07 53 32" src="https://github.com/user-attachments/assets/7298ac61-1f31-4e32-a841-2fff897b5887">






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

<img width="718" alt="Screenshot 2022-09-28 at 15 17 41" src="https://user-images.githubusercontent.com/39365725/192776509-1d621cea-8f1d-46e5-9b49-71058657a51b.png">

Batches page

<img width="1439" alt="Screenshot 2022-09-28 at 15 18 45" src="https://user-images.githubusercontent.com/39365725/192776810-751c7ab7-feef-4c50-bc45-45f1ba78a21b.png">

CSV upload Page

<img width="1432" alt="Screenshot 2022-09-28 at 15 19 49" src="https://user-images.githubusercontent.com/39365725/192776929-223fb1ea-b6d2-4809-934f-a2ee897ef069.png">

Upload Progress page

<img width="716" alt="Screenshot 2022-09-28 at 15 22 14" src="https://user-images.githubusercontent.com/39365725/192777396-19d4097c-835d-4ddc-9219-4b8a2a9c3055.png">




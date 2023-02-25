# Installation

## Prerequisites

To use this application, you need to have installed :
* Ruby >= 3.0.0, preferably with RVM as the installation method
* MongoDB >= 6.0.0 as the database system

## Install dependencies

Go in the project folder and run the command :

```
gem install bundler
bundler install
```

## Environment variable

If you execute the project in development, you do not need environment variables. In production though, you need a `API_URL` variable with the URL to the API without the trailing slash (example : `http://localhost:9292`, __NOT__ `http://localhost:9292/`).

## Run the application

Go to your application folder and run the `rackup` command, you can access the application at `http://localhost:9292`

## Run tests

To run tests, just go to a terminal and run `bundle exec rspec`

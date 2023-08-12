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

Copy the template in a .env file

```bash
cp env.template .env
```

Edit the `.env` file to add a valid value to the `MONGODB_URL` variable to plug the API on your database.

## Run the application

Go to your application folder and run the `bundle exec rackup` command, you can access the application at `http://localhost:9292`

## Run tests

To run tests, just go to a terminal and run `bundle exec rspec`

## Lint the application

TO run the linter, use the `rubocop` gem with the command `bundle exec rubocop`. For now only controllers have been linted.
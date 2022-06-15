# Fakepay integration

[![Linter Breakman](https://github.com/Lukasz-Ziemnicki/fakepay/actions/workflows/ci.yml/badge.svg)](https://github.com/Lukasz-Ziemnicki/fakepay/actions) &nbsp;

`Maxio/Chargify` job interview task.

# Table of contents

- [Technological stack](#technological-stack)
- [Database](#database)
- [Local setup](#local-setup)
- [Tests coverage](#tests-coverage)

## Technological stack

*:gem: &nbsp; Ruby 3.0.0\
:light_rail: &nbsp; Rails 7.0.3*

## Database

*:minidisc: &nbsp; Postgresql 12.7*

## Local setup

Install correct `ruby` using rvm (or favourite ruby version manager) & right postgreql version and finally run:

```
bundle
```

Run migrations:

```
rails db:create && rails db:migrate:with_data
```

Check how does it work locally using `curl`.
```
curl -d '@data.json' -H 'Content-Type: application/json' -X POST http://localhost:3000/api/v1/customers
```

or any other favourite tool.

`data.json` file in the project root possess correct request body structure with data passed to Rails app (adjust only `subscription_id` with correct `UUID` value generated during subscriptions seeding).

## Tests coverage

:microscope: &nbsp; Tested with: [RSpec for Rails 6+](https://github.com/rspec/rspec-rails).

# Digidentity Assignment: The Ruby Bank

The key to the assignment is the method and technique. The user interface is less important.

1. Build a simple rails banking app.
2. Via the console you can create users with password.
3. The user must be able to log in.
4. Via the console you can give the user credit.
5. User has a bank account with balance.
6. Users can transfer money to each other.
7. Users may not have a negative balance on their account.
8. It must be traceable how a user obtained a certain balance.
9. It is important that money cannot just disappear or appear into account.

## Usage

Make sure you have Ruby 3.1 installed:

```
rbenv install 3.1.1
```

And install all dependencies:

```
bundle install
```

Prepare the database with test data (using seeds)

```
bundle exec rails db:reset
```

Run the webserver at http://localhost:3000

```
bundle exec rails s
```

You can login using `test+1@digidentity.com` and password `Welkom123!`.

## Test data

The seed command adds a credit to a customer, and a transaction between two customers.

To add more transaction data, you can use FactoryBot definitions in the rails console:

```rb
# Loading development environment (Rails 7.0.2.3)
# irb(main):001:0>
include FactoryBot::Syntax::Methods

customer = Customer.find_by(email: "test+1@digidentity.com")
# Give 100 euro credit to customer:
create(:transaction, :credit, amount_cents: 100_00, receiver: customer)
```

## Expectations

- Transactions have a `currency` attached to them. Right now they always default to `EUR`, but could be extended
- Models use `money-rails` under the hood. Calculations of balance and transactions happen using this gem
- To minimize complex logic in controllers, "request parameter models" are used. Request parameter models have the same idea as Laravel Request validations. To validate your request params separate from database model params.
- In order to avoid heavy database queries to calculate balance from all transactions made, the balance has been denormalized as a field in `Customer#balance_cents`. In order to avoid race conditions with keeping this `balance_cents` field, the way to update this is by using `Customer#update_balance_atomic!`. This locks the customer row in the database, and ensures it gets updated atomically.

## Tests

To showcase skill in testing frameworks, RSpec unit and integration tests have been added. Run the test suite using:

```
bundle exec rspec
```

- `rspec/(models|request_models)`: examples of unit tests
- `rspec/system`: examples of integration tests. Uses `rack_test` driver

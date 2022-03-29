include FactoryBot::Syntax::Methods

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

sender = create(
  :customer,
  email: "test+1@digidentity.com",
  password: "Welkom123!",
  account_number: "NL26ABNA012345678"
)

receiver = create(
  :customer,
  email: "test+2@digidentity.com",
  password: "Welkom123!",
  account_number: "NL25ABNA012345678"
)

# Give credit for customer to use
create(
  :transaction, :credit, :recalculate_balance,
  amount_cents: 100_00, receiver: sender
)

# Create a transaction to another customer
create(
  :transaction, :transfer, :recalculate_balance,
  amount_cents: 20_00, sender:, receiver:
)

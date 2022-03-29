FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email(domain: "digidentity.com") }
    password { Faker::Internet.password }
    balance_cents { 0 }
    account_number { Faker::Bank.iban(country_code: "nl") }
    account_holder do
      [
        Faker::Name.initials(number: 1),
        Faker::Name.last_name
      ].join(". ")
    end

    after(:build) do |user|
      user.password ||= Faker::Internet.password
      user.password_confirmation = user.password
    end
  end
end

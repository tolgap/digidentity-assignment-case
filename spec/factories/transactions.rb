FactoryBot.define do
  factory :transaction do
    amount_cents { rand(1..50_00) }
    currency { "EUR" }
    transaction_type { "credit" }
    association :receiver, factory: :customer

    trait :transfer do
      transaction_type { "transfer" }
      association :sender, factory: :customer
    end

    trait :credit do
      transaction_type { "credit" }
    end
  end
end

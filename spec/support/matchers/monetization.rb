require "rspec/expectations"

RSpec::Matchers.define :eql_monetized do |expected_in_cents, currency|
  match do |actual|
    actual == Money.new(expected_in_cents, currency || "EUR")
  end

  failure_message do |actual|
    "Expected #{Money.new(expected_in_cents).inspect} \nGot #{actual.inspect}"
  end
end

RSpec::Matchers.define :be_monetized do |_expected_in_cents|
  match do |actual|
    actual.is_a?(Money)
  end

  failure_message do |actual|
    "Expected #{actual.inspect} to be a Money object"
  end
end

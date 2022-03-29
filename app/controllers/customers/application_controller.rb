module Customers
  class ApplicationController < ::ApplicationController
    before_action :authenticate_customer!
  end
end

class User < ApplicationRecord
  include ChargebeeRails::Customer

  # Added by ChargebeeRails.
  has_one :subscription
  serialize :chargebee_data, JSON
end

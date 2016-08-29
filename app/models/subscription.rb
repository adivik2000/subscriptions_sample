class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_one :payment_method
  include ChargebeeRails::Subscription
  serialize :chargebee_data, JSON
end

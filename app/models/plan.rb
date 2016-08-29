class Plan < ApplicationRecord
  has_many :subscriptions
  serialize :chargebee_data, JSON
end

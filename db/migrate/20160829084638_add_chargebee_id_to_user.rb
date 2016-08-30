class AddChargebeeIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :chargebee_id, :string
    add_column :users, :event_last_modified_at, :datetime
    add_column :users, :chargebee_data, :text
  end
end

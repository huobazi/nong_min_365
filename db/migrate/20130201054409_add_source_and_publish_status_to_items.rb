class AddSourceAndPublishStatusToItems < ActiveRecord::Migration
    add_column :items, :publis_status, :integer, :default => 0
    add_column :items, :source, :string
end

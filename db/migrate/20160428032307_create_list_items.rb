class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.string :description
      t.integer :list_id
      t.integer :priority
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

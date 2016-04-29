class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start
      t.datetime :end
      t.integer :calendar_id

      t.timestamps
    end
  end
end

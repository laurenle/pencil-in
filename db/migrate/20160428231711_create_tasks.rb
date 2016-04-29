class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.datetime :start_time
      t.integer :duration
      t.timestamps
    end
  end
end

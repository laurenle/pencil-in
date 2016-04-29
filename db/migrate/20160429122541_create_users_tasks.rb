class CreateUsersTasks < ActiveRecord::Migration
  def change
    create_table :users_tasks do |t|
      t.references :user
      t.references :task
      t.timestamps null:false
    end
  end
end

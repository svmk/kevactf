class CreateUserAnswers < ActiveRecord::Migration
  def self.up
    create_table :user_answers do |t|
      t.integer :user_id
      t.integer :quest_id
      t.text :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_answers
  end
end

class CreateQuestsUsers < ActiveRecord::Migration
  def self.up
    create_table :quests_users,:id=>false do |t|
      t.integer :quest_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :quests_users
  end
end

class CreateQuestTypes < ActiveRecord::Migration
  def self.up
    create_table :quest_types do |t|
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :quest_types
  end
end

class CreateQuests < ActiveRecord::Migration
  def self.up
    create_table :quests do |t|
      t.text :title
      t.text :description
      t.text :syscmd
      t.integer :price
      t.integer :quest_type_id
      t.boolean :show

      t.timestamps
    end
  end

  def self.down
    drop_table :quests
  end
end

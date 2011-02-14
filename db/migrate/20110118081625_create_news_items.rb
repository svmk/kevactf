class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.text :title
      t.text :content
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :news_items
  end
end

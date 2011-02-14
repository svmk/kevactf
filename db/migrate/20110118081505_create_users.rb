class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :nickname
      t.string :realname
      t.text :university
      t.text :email
      t.text :password
      t.boolean :enabled
      t.boolean :admin
      t.integer :price
      t.text :hash
      t.time :last_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

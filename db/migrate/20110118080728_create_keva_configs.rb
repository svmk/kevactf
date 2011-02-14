class CreateKevaConfigs < ActiveRecord::Migration
  def self.up
    create_table :keva_configs do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
    KevaConfig.create :key => 'irc'  , :value => ''
    KevaConfig.create :key => 'email', :value => ''
    KevaConfig.create :key => 'news_comment', :value=>'Disabled'
    KevaConfig.create :key => 'register_end', :value => ''
    KevaConfig.create :key => 'register_enabled', :value => 'Disabled'
    KevaConfig.create :key => 'game_begin', :value => ''
    KevaConfig.create :key => 'game_end', :value => ''
    KevaConfig.create :key => 'game_enabled', :value => 'Disabled'
    KevaConfig.create :key => 'main_page_content', :value => ''
    KevaConfig.create :key => 'main_page_content', :value => ''
    KevaConfig.create :key => 'user_dalay', :value => ''
  end

  def self.down
    drop_table :keva_configs
  end
end

class Comment < ActiveRecord::Base
  belongs_to :news_item
  belongs_to :user
  validates :title,:length => {:maximum=>1024}
  validates :content,:presence => true
end

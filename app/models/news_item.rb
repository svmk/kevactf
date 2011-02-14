class NewsItem < ActiveRecord::Base
  belongs_to :user
  has_many   :comment
  validates :title,:length => {:maximum=>1024}
  validates :content,:presence => true
end

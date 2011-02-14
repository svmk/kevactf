class User < ActiveRecord::Base
  has_many :comment
  has_many :news_item
  has_and_belongs_to_many   :quest
  validates :nickname,:presence => true,:length => { :minimum => 4,:maximum=>100}
  validates :realname,:presence => true,:length => { :minimum => 4,:maximum=>300}
  validates :university,:presence => true,:length => { :minimum => 4,:maximum=>300}
  validates :email,:presence => true,:length => { :minimum => 5,:maximum=>100},
    :format => { :with => /^[a-zA-Z0-9._%-]*@[a-zA-Z0-9._%-]*$/, :on => :create }
  validates_uniqueness_of :nickname
  validates_uniqueness_of :realname
  validates_uniqueness_of :email
end
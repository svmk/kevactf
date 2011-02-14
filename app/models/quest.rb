class Quest < ActiveRecord::Base
belongs_to :quest_type
has_many   :hint
has_and_belongs_to_many   :user
end

class ActivityComponent < ActiveRecord::Base
  belongs_to :activity
  belongs_to :component
end

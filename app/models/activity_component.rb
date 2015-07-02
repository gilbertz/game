class ActivityComponent < ActiveRecord::Base
  belones_to :activity
  belongs_to :component
end

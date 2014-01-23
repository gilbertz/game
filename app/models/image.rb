class Image < ActiveRecord::Base
  belongs_to :material

  validates :title, presence: true
end

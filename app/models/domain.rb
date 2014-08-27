class Domain < ActiveRecord::Base
  def get_name
    self.name.gsub("*", rand(100).to_s )
  end
end

class District < ActiveRecord::Base

  has_many :user
  has_many :operative_record

end

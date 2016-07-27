class OperativeRecord < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :stealing_auto
end

class OperativeRecord < ActiveRecord::Base
  resourcify
  belongs_to :user
end

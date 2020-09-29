class Game < ApplicationRecord
  belongs_to :user
  has_many :reports
  has_many :ratings
  has_many :comments
end

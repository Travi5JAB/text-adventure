class Game < ApplicationRecord
  belongs_to :user
  has_many :reports
  has_many :ratings
end

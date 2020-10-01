class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         authentication_keys: [:username]

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

# log in not case sensative
  before_save do
    self.username.capitalize! if self.username
  end

  def self.find_for_authentication(conditions)
    conditions[:username].capitalize!
    super(conditions)
  end


# redirect to
  def after_sign_in_path_for(user)
    cookies[:name] = current_user.username
    "/"
  end

  def after_sign_up_path_for(user)
    cookies[:name] = current_user.username
    "/"
  end

  # associations
  has_many :games
  has_many :ratings
  has_many :reports
  has_many :comments

  has_many :visits, class_name: "Ahoy::Visit"

end

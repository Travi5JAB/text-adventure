class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username]

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  def email_changed?
    false
  end

# log in not case sensative
  before_save do
    self.username.capitalize! if self.username
  end

  def self.find_for_authentication(conditions)
    conditions[:username].capitalize!
    super(conditions)
  end

end

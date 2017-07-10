class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_one :role

  before_create :set_role, :set_auth_token

  scope :users_not_empty, -> { select('1').limit(1).count }

  def admin?
    self.role_id == 2
  end

  private

  def set_role
    if User.users_not_empty == 0
      self.role_id = 2
    else
      self.role_id = 1
    end
  end

  def set_auth_token
    self.auth_token = SecureRandom.uuid.gsub(/\-/,'')
  end
end

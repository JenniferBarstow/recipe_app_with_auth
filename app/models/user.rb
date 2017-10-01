class User < ActiveRecord::Base
  has_many :recipes
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true
  validates_format_of :email, with: /@/

  def is_admin?
    self.admin == true
  end

  def full_name
    "#{self.first_name } #{self.last_name} "
  end

end

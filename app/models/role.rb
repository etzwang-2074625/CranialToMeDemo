class Role < ApplicationRecord
	validates :name, presence: true, uniqueness: true
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  attr_writer :privileges

  before_save :do_before_save

  def privileges
    if not @privileges
      if not privilege_string.blank?
        @privileges = Set.new(eval(privilege_string))
      else
        @privileges = Set.new([])
      end
    end
    @privileges
  end

  def do_before_save
    # p privileges.to_a.inspect
    self[:privilege_string] = privileges.to_a.inspect
  end
end

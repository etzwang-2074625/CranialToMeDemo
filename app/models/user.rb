require 'net-ldap'

class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  mount_uploader :signature, SignatureUploader

  has_secure_password

  before_save { |user| user.user_login = email.downcase if email.present?}
  before_save { |user| user.email = email.downcase if email.present?}

  validates :email, presence: true, uniqueness: true

  validates :user_firstname, uniqueness: { scope: :user_lastname } # rubocop:disable Rails/UniqueValidationWithoutIndex

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :data_repositories, dependent: :destroy

  scope :with_search, -> search { where("LOWER(CONCAT_WS(' ', user_firstname, user_lastname)) LIKE ? ", '%' + search.downcase.split(' ').join('%') + '%') if search.present?}
  scope :current, -> { where(status: "active")}
  scope :with_role, -> role_id {
    where("status='active' and ('all' = ? or users.user_id in (select user_id from user_roles where role_id = ?))", role_id, role_id).order('user_lastname') if role_id.present?
  }

 
  def delegations 
    result = []
    result = Delegation.where(project_pi_id: self.id)
    result
  end  

  def pi_delegates
    result = []
    if delegations.present?
      result = delegations.collect{|d| d.pi_delegate}
    end
    result
  end

  def delegate_pis
    result = []
    if delegations.present?
      result = delegations.collect{|d| d.project_pi}
    end
    result
  end

  def projects
    Project.where(pi_email: self.user_login)
  end

  def center_name
    center = UsersHelper::AWARD_CENTERS.select{|i| i[2]==self.center_id}.first
    if center.present?
      return "#{center[0]} - #{center[1]}"
    end
    nil
  end

 

  # 2019-11-29
  def first_name
    self.user_firstname
  end

   # 2019-11-29
  def last_name
    self.user_lastname
  end

  def full_name
    self.user_firstname + " " + self.user_lastname
  end

  def self.name_like(search)
    search_name = search.downcase.gsub(/[,\s+]/, "") if search.present?
    search_name ||= ""

    users = User.all
    result = []
    if not search_name.blank?
      users.each do |user|
        if user.user_firstname and user.user_lastname
          name = user.user_firstname.downcase+user.user_lastname.downcase
          reverse_name = user.user_lastname.downcase + user.user_firstname.downcase
          if name.slice(search_name) or reverse_name.slice(search_name)
            result << user
          end
        end
      end
      result
    else
      nil
    end
  end

  def role(current_role_id=nil)
    if roles.present?
      if  current_role_id.present? 
        return Role.where(id: current_role_id).first
      else
        return roles.first
      end
    end

    nil
  end

  def role_name(current_role_id=nil)
    if role(current_role_id)
      return role(current_role_id).name
    end
    
    ""
  end

  def ldap_authenticate(password)
    ldap=Net::LDAP.new
    ldap.host = APP_CONFIG['host']
    ldap.port = APP_CONFIG['port']  # ldaps port number is 636
    full_network_id = ""
    full_network_id << user_login
    full_network_id << "@#{APP_CONFIG['ldapdomain']}" if APP_CONFIG['ldapdomain'].present?
    ldap.auth full_network_id,password
    begin
      if ldap.bind
        return 1
      else
        if APP_CONFIG['builtin_users'].split('$').include?(self.user_login.downcase) and self.authenticate(password)
          return 1
        else
          return 0
        end
      end
    rescue
      puts "ldap rescue"
      if APP_CONFIG['builtin_users'].split('$').include?(self.user_login.downcase) and self.authenticate(password)
        return 1
      else
        return 0
      end
    end
  end

  def name
    desc = ""
    desc = "#{user_firstname}" if user_firstname.present?
    desc += " #{user_middlename}" if user_middlename.present?
    desc += " #{user_lastname}" if user_lastname.present?
    desc
  end

  def reverse_name
    desc = ""
    desc = "#{user_lastname}, " if user_lastname.present?
    desc += "#{user_firstname}" if user_firstname.present?
    desc
  end

  def short_name
    desc = ""
    desc = "#{user_firstname[0]}" if user_firstname.present?
    desc += " #{user_lastname}" if user_lastname.present?
    desc
  end

  def name_with_degree
    desc = name
    desc += ", #{degree}" if degree.present?
    desc
  end

  def admin?
    roles.include?(Role.find_by_name('System Administrator'))
  end

  # return true if user has given privilege in any core
  # currrent_user.has_privilege?("PRE_APPROVE")
  def has_privilege?(privilege)
    self.user_roles.each do |r|
      if r.role.privileges.include? (privilege)
        return true
      end
    end
    return false
  end

  # Return true if the user has the given role in currently selected facility
  def has_role?(role_name)
    # return false unless self.facility_selected?
    if role_name == "any"
      self.user_roles.find(:all).each do |tuple|
        return true
      end
    else
      self.user_roles.each do |tuple|
        return true if tuple.role and tuple.role.name == role_name
      end
    end
    return false
  end

  def get_tmp_pwd
    "#{user_firstname[0]}#{user_lastname.downcase}_#{Date.today.year}_#{(1+user_lastname.size).to_s}"
  end

end
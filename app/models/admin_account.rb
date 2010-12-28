require 'digest/sha1'

class AdminAccount < ActiveRecord::Base

  after_destroy :last_admin_check

  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = AdminAccount.encrypted_password(self.password, self.salt)
  end

  def self.authenticate(name, password)
    admin = self.find_by_name(name)
    if admin
      expected_password = encrypted_password(password, admin.salt)
      if admin.hashed_password != expected_password
        admin = nil
      end
    end
    admin
  end

private

  def last_admin_check
    if AdminAccount.count.zero?
      raise "Can't delete last admin"
    end
  end

  def password_non_blank
    errors.add(:password, "Missing password" ) if hashed_password.blank?
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end


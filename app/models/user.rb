class User < ActiveRecord::Base
  
  has_many :entities
  has_many :comments
  
  validates_presence_of :uname
  validates_uniqueness_of :uname
  
  attr_accessor :password_confirmation
  
  SALT = '1g0rrr'
  
  def self.authenticate(uname, password)
    user = self.find_by_uname(uname)
    if user
       if user.password != self.encrypted_password(password)
         user = nil
       else
         user
       end
    end
  end
  
  
  def self.encrypted_password(password)
    
    string_to_hash = password + SALT
    Digest::SHA1.hexdigest(string_to_hash)
    
  end
  
  def before_destroy
    FileUtils.rm_rf("#{IMAGES_STORAGE_PATH}/users/#{self[:id]}/")
  end
  
end

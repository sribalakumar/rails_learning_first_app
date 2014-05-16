class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_save :create_remember_token
  #attr_accessible :name, :email, :password, :password_confirmation
  #attr_accessor :name, :password, :email
  validates :name, presence: true, length: { maximum: 50 }
  #below regex fails and the standard email verification Regex is 
  #/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  #got that Regex from http://stackoverflow.com/questions/4770133/rails-regex-for-email-validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts, dependent: :destroy
  validates :password, length: { minimum: 6 }

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end 

  private 

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true 

    # validate :password, length: {minimum: 6}, allow_nil: true 

    after_initialize :ensure_session_token # runs after User.new  

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def check_password?(password)
        object = BCrypt::Password.new(self.password_digest)
        object.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && check_password?(password)
            return user
        else 
            nil 
        end
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    private
    def generate_unique_session_token
        self.session_token = SecureRandom::urlsafe_base64
    end
end

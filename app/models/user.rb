class User < ActiveRecord::Base
   
    has_many :sneakers
    has_secure_password
    validates :username, presence: true
    validates :username, uniqueness: true
    validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
    validates :email, uniqueness: true
end
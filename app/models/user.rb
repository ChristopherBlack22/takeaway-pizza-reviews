class User < ActiveRecord::Base
    has_secure_password
    has_many :reviews
    has_many :takeaway_pizzas, through: :reviews

    validates :username, presence: true
    validates :password_digest, :email, presence: true
    validates :username, uniqueness: true
end 
class User < ActiveRecord::Base
  include ContentHelper
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :ratings, dependent: :destroy
  has_many :movies, through: :ratings

  has_many :recommendations, dependent: :destroy
  has_many :movies, through: :recommendations

end

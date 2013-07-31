class Director < ActiveRecord::Base

  attr_accessible :name
  has_many :directors_movies, dependent: :destroy
  has_many :movies, through: :directors_movies

  validates :name, presence: true

  posify do
    # The searchable content.
    [self.name].join ' '
  end

end

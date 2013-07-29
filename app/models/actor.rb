class Actor < ActiveRecord::Base

  attr_accessible :name
  has_many :actors_movies
  has_many :movies, through: :actors_movies

  validates :name, presence: true

  posify do
    # The searchable content.
    [ self.name ].join ' '
  end
  
end

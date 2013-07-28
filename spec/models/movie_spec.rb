 require 'spec_helper'

# describe 'Movie' do

#   describe 'Content-Algorithm' do
#     before(:all) { 
#     FactoryGirl.create(:actor)
#     FactoryGirl.create(:director)
#     FactoryGirl.create(:genre)  
#     5.times { FactoryGirl.create(:trilogy) 
#       FactoryGirl.create(:actors_movies)
#       FactoryGirl.create(:directors_movies)
#       FactoryGirl.create(:genres_movies)   } }

#     it "should return all movies in a series(same director,actor, and genre)" do
#       chosen_movie = Movie.first
#       expect(Movie.unit_cluster(chosen_movie,5).length).to eq(4)
#     end
#   end

# end

# # comedy = build(:genre, name: 'Comedy')
# # horror = create(:genre, name: 'Horro')

# # name: 'Comedy'

# # genre = build(:genre)
puts '--------'
movie = FactoryGirl.create(:trilogy).title
genre = FactoryGirl.create(:genre)
actor = FactoryGirl.create(:actor)
director = FactoryGirl.create(:director)
movie << genre << actor << director
puts '--------'

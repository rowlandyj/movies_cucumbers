require 'spec_helper'

describe 'Movie' do

  describe 'Content-Algorithm' do
    let!(:user) { FactoryGirl.create(:user) }

    before(:each) { 
      actor = FactoryGirl.create(:actor)
      director = FactoryGirl.create(:director)
      genre = FactoryGirl.create(:genre)

      5.times { FactoryGirl.create(:trilogy) }
      Movie.all.each do |movie|
        movie.genres << genre
        movie.actors << actor
        movie.directors << director
      end
    }

    it "should return all movies in a series(same director,actor, and genre)" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,5,user)).to include(Movie.find(5),Movie.find(2),Movie.find(3),Movie.find(4))
    end

    it "should return a list of length 10 if a rating of 5 is given" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,5,user).length).to eq(10)
    end

    it "should return a list of length 9 if a rating of 4 is given" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,4,user).length).to eq(9)
    end

    it "should return a list of length 5 if a rating of 3 is given" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,3,user).length).to eq(5)
    end

    it "should return a list of length 2 if a rating of 2 is given" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,2,user).length).to eq(2)
    end

    it "should return a list of length 1 if a rating of 1 is given" do
      chosen_movie = Movie.first
      expect(Movie.unit_cluster(chosen_movie,1,user).length).to eq(1)
    end
  end

end


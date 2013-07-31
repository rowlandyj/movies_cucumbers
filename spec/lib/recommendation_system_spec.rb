require 'spec_helper'
include RecommendationSystem

describe 'Content-Algorithm' do

  describe 'Unit Cluster' do
    let!(:user) { FactoryGirl.create(:user) }

    #7 points where movies are added, no deletion of duplicates for unit cluster
    let(:max) { (Movie.all.count-1)*7}

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
      expect(unit_cluster(Movie.first,5,user)).to include(Movie.find(2),Movie.find(3),Movie.find(4),Movie.find(5))
    end

    it "should return a list of length 10 if a rating of 5 is given" do
      expect(unit_cluster(Movie.first,5,user).length).to be_between(max,REC_LIMIT[4])
    end

    it "should return a list of length 9 if a rating of 4 is given" do
      expect(unit_cluster(Movie.first,4,user).length).to be_between(max,REC_LIMIT[3])
    end

    it "should return a list of length 5 if a rating of 3 is given" do
      expect(unit_cluster(Movie.first,3,user).length).to be_between(REC_LIMIT[2], max)
    end

    it "should return a list of length 2 if a rating of 2 is given" do
      expect(unit_cluster(Movie.first,2,user).length).to be_between(REC_LIMIT[1], max)
    end

    it "should return a list of length 1 if a rating of 1 is given" do
      expect(unit_cluster(Movie.first,1,user).length).to be_between(REC_LIMIT[0], max)
    end
  end
end

describe "Collab-Algorithm" do

  describe "Pearson Correlation Coefficient" do
    before(:each) {
      @user1 = FactoryGirl.create(:collab_user)
      @user2 = FactoryGirl.create(:collab_user)
      @user3 = FactoryGirl.create(:collab_user)
      @user4 = FactoryGirl.create(:collab_user)

      @movie1 = FactoryGirl.create(:movie)
      @movie1.genres << FactoryGirl.create(:genre)
      @movie1.actors << FactoryGirl.create(:actor)
      @movie1.directors << FactoryGirl.create(:director)

      @movie2 = FactoryGirl.create(:movie)
      @movie2.genres << FactoryGirl.create(:genre)
      @movie2.actors << FactoryGirl.create(:actor)
      @movie2.directors << FactoryGirl.create(:director)

      @movie3 = FactoryGirl.create(:movie)
      @movie3.genres << FactoryGirl.create(:genre)
      @movie3.actors << FactoryGirl.create(:actor)
      @movie3.directors << FactoryGirl.create(:director)

      @movie4 = FactoryGirl.create(:movie)
      @movie4.genres << FactoryGirl.create(:genre)
      @movie4.actors << FactoryGirl.create(:actor)
      @movie4.directors << FactoryGirl.create(:director)

      @movie5 = FactoryGirl.create(:movie)
      @movie5.genres << FactoryGirl.create(:genre)
      @movie5.actors << FactoryGirl.create(:actor)
      @movie5.directors << FactoryGirl.create(:director)

      @user2.ratings << Rating.create(movie_id: 1, rating_value: 5)
      @user3.ratings << Rating.create(movie_id: 2, rating_value: 5)
      @user3.ratings << Rating.create(movie_id: 3, rating_value: 4)
      @user3.ratings << Rating.create(movie_id: 5, rating_value: 3)
      @user3.ratings << Rating.create(movie_id: 4, rating_value: 3)
      @user4.ratings << Rating.create(movie_id: 2, rating_value: 5)
      @user4.ratings << Rating.create(movie_id: 3, rating_value: 5)
      @user4.ratings << Rating.create(movie_id: 5, rating_value: 5)
      @user4.ratings << Rating.create(movie_id: 4, rating_value: 3)

    }

    # PEARSON_CORR_CONTROL_VALUE will be abbreviated to PCCV

    it "get a value of PCCV when user has no ratings" do
      expect(pearson_corr(@user1.ratings, @user2.ratings)).to eq(PEARSON_CORR_CONTROL_VALUE)
    end

    it "get a value of PCCV when no rated movies are similar to other users" do
      expect(pearson_corr(@user3.ratings, @user2.ratings)).to eq(PEARSON_CORR_CONTROL_VALUE)
      expect(pearson_corr(@user2.ratings, @user3.ratings)).to eq(PEARSON_CORR_CONTROL_VALUE)
    end

    it "get a value closer to 1 than PCCV when two users have some similar ratings" do
      expect(pearson_corr(@user4.ratings, @user3.ratings)).to be_between(-1,1)
    end
  end
end



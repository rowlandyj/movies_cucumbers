require 'spec_helper'

describe 'Movie' do

  it "should have all the movies" do
    expect(Movie.all.count).to eq(8669)
  end

end

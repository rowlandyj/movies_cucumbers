require 'spec_helper'

describe 'Movie' do

  describe 'Content-Algorithm' do
    before(:all) { 5.times {FactoryGirl.create(:trilogy) } }
    it "should return all movies in a series(same director,actor, and genre)" do
      
    end
  end

end

require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "amount is shown and ratings are listed correctly" do
    create_ratings

    visit ratings_path
    expect(page).to have_content "Number of ratings: #{Rating.count}"

    Rating.all.each do |rating|
      expect(page).to have_content rating
    end

  end

  it "is removed from the database, when the user removes it" do
    FactoryGirl.create :rating, beer:beer1, user:user, score:26
    visit user_path(user)

    expect {
      click_link "delete"
    }.to change{ user.ratings.count }.from(1).to(0)
  end

  it "are shown correctly on the user's page" do
    create_ratings
    user2 = FactoryGirl.create(:user, username:"User2")
    FactoryGirl.create :rating, beer:beer1, user:user2, score:49
    FactoryGirl.create :rating, beer:beer2, user:user2, score:49

    visit user_path(user)

    expect(user.ratings.count).to eq(4)
    expect(page).to have_content "Has rated 4 beers"

    user.ratings.all.each do |rating|
      expect(page).to have_content rating
    end

    user2.ratings.all.each do |rating2|
      expect(page).not_to have_content rating2
    end
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

def create_ratings()
  FactoryGirl.create :rating, beer:beer1, user:user, score:20
  FactoryGirl.create :rating, beer:beer2, user:user, score:14
  FactoryGirl.create :rating, beer:beer1, user:user, score:24
  FactoryGirl.create :rating, beer:beer2, user:user, score:3
end
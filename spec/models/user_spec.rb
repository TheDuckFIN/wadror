require 'rails_helper'

RSpec.describe User, type: :model do

	it "has the username set correctly" do
		user = User.new username:"Pekka"
		
		expect(user.username).to eq("Pekka")
	end

	it "is not saved without a password" do
		user = User.create username:"Pekka"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is not saved with too short password" do
		user = User.create username:"Pekka", password:"ab", password_confirmation:"ab"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is not saved with password containing only letters" do
		user = User.create username:"Pekka", password:"abcdefgh", password_confirmation:"abcdefgh"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is saved with a proper password" do
		user = FactoryGirl.create(:user)

		expect(user).to be_valid
		expect(User.count).to eq(1)
	end

	describe "favorite brewery" do
		let(:user) { FactoryGirl.create(:user) }

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_brewery)
		end

		it "without ratings does not have one" do
			expect(user.favorite_brewery).to eq(nil)
		end

		it "is the brewery of the only rated beer if only one rating" do
			brewery = create_brewery_containing_beer_with_rating(user, 10)

			expect(user.favorite_brewery).to eq(brewery)
		end

		it "is the brewery containing highest average rating from user of all its beers if several rated" do
			create_brewery_containing_beers_with_ratings(user, 4, 7, 3, 5)
			create_brewery_containing_beers_with_ratings(user, 14, 2, 8, 5)
			best = create_brewery_containing_beer_with_rating(user, 25)

			expect(user.favorite_brewery).to eq(best)
		end
	end

	describe "favorite style" do
		let(:user){ FactoryGirl.create(:user) }

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_style)
		end

		it "without ratings does not have one" do
			expect(user.favorite_style).to eq(nil)
		end

		it "is the style of the only rated beer if only one rating" do
			beer = create_beer_with_rating(user, 10)

			expect(user.favorite_style).to eq(beer.style)
		end

		it "is the style of the beer which has highest average rating from the user if several rated" do
			create_beers_with_ratings_and_styles(user, "Lager", 2, 4, 5)
			create_beers_with_ratings_and_styles(user, "Ölger", 4, 4, 8)
			best = create_beer_with_rating_and_style(user, "Paras", 25)

			expect(user.favorite_style).to eq(best.style)
		end
	end

	describe "favorite beer" do
		let(:user){ FactoryGirl.create(:user) }

		it "has method for determining one" do
			expect(user).to respond_to(:favorite_beer)
		end

		it "without ratings does not have one" do
			expect(user.favorite_beer).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = create_beer_with_rating(user, 10)

			expect(user.favorite_beer).to eq(beer)
		end

        it "is the one with highest rating if several rated" do
        	create_beers_with_ratings(user, 5, 9, 10, 15, 12)
			best = create_beer_with_rating(user, 25)

			expect(user.favorite_beer).to eq(best)
	    end

	end

	describe "with a proper password" do
		let(:user){ FactoryGirl.create(:user) }

		it "is saved" do
			expect(user).to be_valid
			expect(User.count).to eq(1)
		end

		it "and with two ratings, has the correct average rating" do
			user.ratings << FactoryGirl.create(:rating)
			user.ratings << FactoryGirl.create(:rating2)

			expect(user.ratings.count).to eq(2)
			expect(user.average_rating).to eq(15.0)
		end
	end

end

def create_beer_with_rating(user, score)
	beer = FactoryGirl.create(:beer)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer
end	

def create_beers_with_ratings(user, *scores)
	scores.each do |score|
		create_beer_with_rating(user, score)
	end
end

def create_beer_with_rating_and_style(user, style_name, score)
	style = FactoryGirl.create(:style, name:style_name)
	beer = FactoryGirl.create(:beer, style:style)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer
end	

def create_beers_with_ratings_and_styles(user, style, *scores)
	scores.each do |score|
		create_beer_with_rating_and_style(user, style, score)
	end
end	

def create_brewery_containing_beer_with_rating(user, score)
	brewery = FactoryGirl.create(:brewery)
	beer = FactoryGirl.create(:beer, brewery:brewery)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	brewery
end

def create_brewery_containing_beers_with_ratings(user, *scores)
	brewery = FactoryGirl.create(:brewery)
	scores.each do |score|
		beer = create_beer_with_rating(user, score)
		beer.brewery = brewery
		beer.save
	end
end
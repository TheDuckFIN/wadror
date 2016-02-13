require 'rails_helper'

include Helpers

describe "Beer" do

	before :each do
		FactoryGirl.create(:user)
		sign_in(username:"Pekka", password:"Foobar1")
	end

	it "is added when the given name is correct" do
		visit new_beer_path

		fill_in('beer_name', with:"Kalja")

		expect {
			click_button "Create Beer"
		}.to change{Beer.count}.from(0).to(1)
	end


	it "is not added when name is empty" do
		visit new_beer_path

		click_button "Create Beer"

		expect(Beer.count).to eq(0)
	end
end
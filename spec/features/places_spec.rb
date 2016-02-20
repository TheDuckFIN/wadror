require 'rails_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
			[ Place.new(name:"Oljenkorsi", id: 1) ]
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
	end

	it "if multiple returned by the API, they are shown at the page" do
		allow(BeermappingApi).to receive(:places_in).with("tuusula").and_return(
			[ Place.new(name:"Finnegans", id: 1), Place.new(name:"Päämaja", id: 2) ]
		)

		visit places_path
		fill_in('city', with: 'tuusula')
		click_button "Search"

		expect(page).to have_content "Finnegans"
		expect(page).to have_content "Päämaja"
	end

	it "if none are returned by the API, error is shown at the page" do
		allow(BeermappingApi).to receive(:places_in).with("lohja").and_return(
			[]
		)

		visit places_path
		fill_in('city', with: 'lohja')
		click_button "Search"

		expect(page).to have_content "No locations in lohja"
	end
end
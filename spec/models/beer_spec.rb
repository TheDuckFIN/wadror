require 'rails_helper'

RSpec.describe Beer, type: :model do
  
	it "is saved successfully with valid parameters" do
		beer = Beer.create name:"Olvi I", style:"Lager"

		expect(beer.valid?).to be(true)
		expect(Beer.count).to eq(1)
	end

	it "is not saved when name not specified" do
		beer = Beer.create style:"Lager"

		expect(beer.valid?).to be(false)
		expect(Beer.count).to eq(0)
	end

	it "is not saved when style not specified" do
		beer = Beer.create name:"Olvi I"

		expect(beer.valid?).to be(false)
		expect(Beer.count).to eq(0)
	end

end

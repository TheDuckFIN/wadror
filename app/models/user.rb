class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	has_many :ratings, dependent: :destroy
	has_many :memberships, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :beer_clubs, through: :memberships

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/ }

	def favorite_beer
		return nil if ratings.empty?
    	ratings.order(score: :desc).limit(1).first.beer
	end

	def favorite_brewery
		return nil if ratings.empty?
		
		sum = {}
		amount = {}

		ratings.all.each do |rating|
			brewery = find_brewery_by_beer_id(rating.beer_id).id

			if sum[brewery].nil?
				sum[brewery] = rating.score
				amount[brewery] = 1
			else
				sum[brewery] += rating.score
				amount[brewery] += 1
			end
		end

		average = calculate_average(sum, amount)

		fav_id = average.max_by { |k, v| v }[0]

		Brewery.find_by id:fav_id
	end

	def favorite_style
		return nil if ratings.empty?
	
		sum = {}
		amount = {}

		ratings.all.each do |rating|
			style = find_style_by_beer_id(rating.beer_id)

			if sum[style].nil?
				sum[style] = rating.score
				amount[style] = 1
			else
				sum[style] += rating.score
				amount[style] += 1
			end
		end

		average = calculate_average(sum, amount)

		average.max_by { |k, v| v }[0]
	end

	def calculate_average(sum, amount)
		average = {}

		sum.each do |k, v|
			average[k] = v.to_f / amount[k]
		end

		average
	end

	def find_style_by_beer_id(beer_id)
		beer = Beer.find_by id:beer_id
		beer.style
	end

	def find_brewery_by_beer_id(beer_id)
		beer = Beer.find_by id:beer_id
		brewery = Brewery.find_by id:beer.brewery_id
		
		brewery
	end

end

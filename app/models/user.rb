class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	has_many :ratings, dependent: :destroy
	has_many :memberships, dependent: :destroy
	has_many :beers, -> { distinct }, through: :ratings
	has_many :beer_clubs, through: :memberships

    has_many :confirmed_memberships, -> { where confirmed: true }, class_name: "Membership"
    has_many :unconfirmed_memberships, -> { where confirmed: [nil, false] }, class_name: "Membership"

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/ }

	def self.top_raters(n)
		User.all.sort_by{ |u| -(u.ratings.count||0) }.first(n)
	end

	def favorite_beer
		return nil if ratings.empty?
    	ratings.order(score: :desc).limit(1).first.beer
	end

	def rating_of(category, item)
		ratings_of = ratings.select{ |r| r.beer.send(category)==item }
		ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
	end

	def favorite_style
		favorite :style
	end

	def favorite_brewery
		favorite :brewery
	end

	def favorite(category)
		return nil if ratings.empty?

		rated = ratings.map{ |r| r.beer.send(category) }.uniq
		rated.sort_by { |item| -rating_of(category, item) }.first
	end

end

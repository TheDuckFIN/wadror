class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		self.ratings.inject(0.0) { |sum, obj| sum + obj.score } / self.ratings.count
	end
end

class Rating < ActiveRecord::Base
	belongs_to :beer

	def to_s
		beer = Beer.find_by id:self.beer_id
		"#{beer.name} #{self.score}"
	end
end
